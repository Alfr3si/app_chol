<?php
declare(strict_types=1);

require_once __DIR__ . '/config.php';

header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'ok' => false,
        'error' => 'Método no permitido. Usa POST.'
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

$rawBody = file_get_contents('php://input');
$cleanBody = ltrim((string)$rawBody, "\xEF\xBB\xBF");
$payload = json_decode($cleanBody, true);

if (json_last_error() !== JSON_ERROR_NONE || !is_array($payload)) {
    http_response_code(400);
    echo json_encode([
        'ok' => false,
        'error' => 'JSON inválido en el cuerpo de la petición.',
        'json_error' => json_last_error_msg(),
        'bytes_recibidos' => strlen((string)$rawBody)
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

$usuario = $payload['usuario'] ?? null;
$actividades = $payload['actividades'] ?? [];

$googleSub = trim((string)($usuario['google_sub'] ?? ''));
$email     = trim((string)($usuario['email'] ?? ''));
$nombre    = trim((string)($usuario['nombre'] ?? 'Invitado'));
$rangoEdad = trim((string)($usuario['rango_edad'] ?? '8-10 años'));
$avatar    = trim((string)($usuario['avatar_path'] ?? 'assets/image/learning/grupo.webp'));

if ($googleSub === '' || $email === '') {
    http_response_code(422);
    echo json_encode([
        'ok' => false,
        'error' => 'Los campos usuario.google_sub y usuario.email son obligatorios.'
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

if (!is_array($actividades)) {
    http_response_code(422);
    echo json_encode([
        'ok' => false,
        'error' => 'El campo actividades debe ser un arreglo.'
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

try {
    $pdo = getDbConnection();
    $pdo->beginTransaction();

    $sqlUsuario = <<<SQL
        INSERT INTO usuarios (google_sub, email, nombre, rango_edad, avatar_path)
        VALUES (:google_sub, :email, :nombre, :rango_edad, :avatar_path)
        ON DUPLICATE KEY UPDATE
            email = VALUES(email),
            nombre = VALUES(nombre),
            rango_edad = VALUES(rango_edad),
            avatar_path = VALUES(avatar_path),
            actualizado_en = NOW()
    SQL;

    $stmtUsuario = $pdo->prepare($sqlUsuario);
    $stmtUsuario->execute([
        ':google_sub'  => $googleSub,
        ':email'       => $email,
        ':nombre'      => $nombre !== '' ? $nombre : 'Invitado',
        ':rango_edad'  => $rangoEdad !== '' ? $rangoEdad : '8-10 años',
        ':avatar_path' => $avatar !== '' ? $avatar : 'assets/image/learning/grupo.webp',
    ]);

    $stmtId = $pdo->prepare('SELECT id FROM usuarios WHERE google_sub = :google_sub LIMIT 1');
    $stmtId->execute([':google_sub' => $googleSub]);
    $usuarioId = $stmtId->fetchColumn();

    if ($usuarioId === false) {
        throw new RuntimeException('No se pudo recuperar el id del usuario sincronizado.');
    }
    $usuarioId = (int)$usuarioId;

    $sqlActividad = <<<SQL
        INSERT INTO progreso_actividades (
            usuario_id,
            modulo_id,
            actividad_numero,
            actividad_clave,
            completada,
            intentos,
            fecha_completado,
            actualizado_en
        )
        VALUES (
            :usuario_id,
            :modulo_id,
            :actividad_numero,
            :actividad_clave,
            :completada,
            :intentos,
            :fecha_completado,
            :actualizado_en
        )
        ON DUPLICATE KEY UPDATE
            actividad_clave = VALUES(actividad_clave),
            completada = IF(progreso_actividades.completada = 1 OR VALUES(completada) = 1, 1, 0),
            intentos = GREATEST(progreso_actividades.intentos, VALUES(intentos)),
            fecha_completado = COALESCE(progreso_actividades.fecha_completado, VALUES(fecha_completado)),
            actualizado_en = GREATEST(progreso_actividades.actualizado_en, VALUES(actualizado_en))
    SQL;

    $stmtActividad = $pdo->prepare($sqlActividad);
    $procesadas = 0;

    foreach ($actividades as $act) {
        if (!is_array($act)) {
            continue;
        }

        $moduloId        = (int)($act['modulo_id'] ?? 0);
        $actividadNumero = (int)($act['actividad_numero'] ?? 0);
        $actividadClave  = trim((string)($act['actividad_clave'] ?? ''));

        if ($moduloId <= 0 || $actividadNumero <= 0 || $actividadClave === '') {
            throw new InvalidArgumentException('Cada actividad requiere modulo_id, actividad_numero y actividad_clave válidos.');
        }

        $completada = !empty($act['completada']) ? 1 : 0;
        $intentos   = max(1, (int)($act['intentos'] ?? 1));
        $ahora      = date('Y-m-d H:i:s');

        $fechaCompletado = !empty($act['fecha_completado'])
            ? date('Y-m-d H:i:s', strtotime((string)$act['fecha_completado']) ?: time())
            : $ahora;

        $actualizadoEn = !empty($act['actualizado_en'])
            ? date('Y-m-d H:i:s', strtotime((string)$act['actualizado_en']) ?: time())
            : $ahora;

        $stmtActividad->execute([
            ':usuario_id'       => $usuarioId,
            ':modulo_id'        => $moduloId,
            ':actividad_numero' => $actividadNumero,
            ':actividad_clave'  => $actividadClave,
            ':completada'       => $completada,
            ':intentos'         => $intentos,
            ':fecha_completado' => $fechaCompletado,
            ':actualizado_en'   => $actualizadoEn,
        ]);

        $procesadas++;
    }

    $pdo->commit();

    http_response_code(200);
    echo json_encode([
        'ok' => true,
        'usuario_id' => $usuarioId,
        'actividades_procesadas' => $procesadas,
        'mensaje' => 'Sincronización completada correctamente.'
    ], JSON_UNESCAPED_UNICODE);

} catch (Throwable $e) {
    if (isset($pdo) && $pdo instanceof PDO && $pdo->inTransaction()) {
        $pdo->rollBack();
    }

    http_response_code(500);
    echo json_encode([
        'ok' => false,
        'error' => 'Error durante la sincronización.',
        'detalle' => $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
}

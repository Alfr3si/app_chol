<!-- api\config.php -->
<?php
declare(strict_types=1);

function getDbConnection(): PDO
{
    $host = getenv('CHOLAPP_DB_HOST') ?: 'localhost';
    $port = getenv('CHOLAPP_DB_PORT') ?: '3306';
    $name = getenv('CHOLAPP_DB_NAME') ?: 'nuestr71_cholapp_db';
    $user = getenv('CHOLAPP_DB_USER') ?: 'TU_USUARIO_MYSQL_COMPLETO';
    $pass = getenv('CHOLAPP_DB_PASS') ?: 'TU_CONTRASEÑA_MYSQL';

    $dsn = sprintf(
        'mysql:host=%s;port=%s;dbname=%s;charset=utf8mb4',
        $host,
        $port,
        $name
    );

    return new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ]);
}

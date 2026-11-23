CREATE DATABASE IF NOT EXISTS cholapp_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE cholapp_db;

CREATE TABLE IF NOT EXISTS usuarios (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  google_sub VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  nombre VARCHAR(120) NOT NULL DEFAULT 'Invitado',
  rango_edad VARCHAR(30) NOT NULL DEFAULT '8-10 años',
  avatar_path VARCHAR(255) NOT NULL DEFAULT 'assets/image/learning/grupo.webp',
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS progreso_actividades (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT UNSIGNED NOT NULL,
  modulo_id INT NOT NULL,
  actividad_numero INT NOT NULL,
  actividad_clave VARCHAR(60) NOT NULL,
  completada TINYINT(1) NOT NULL DEFAULT 1,
  intentos INT NOT NULL DEFAULT 1,
  fecha_completado DATETIME NOT NULL,
  actualizado_en DATETIME NOT NULL,
  UNIQUE KEY uq_usuario_modulo_act (usuario_id, modulo_id, actividad_numero),
  INDEX idx_progreso_usuario (usuario_id),
  CONSTRAINT fk_progreso_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

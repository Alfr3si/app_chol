<?php
declare(strict_types=1);

function getDbConnection(): PDO
{
    $host = getenv('CHOLAPP_DB_HOST') ?: '127.0.0.1';
    $port = getenv('CHOLAPP_DB_PORT') ?: '3306';
    $name = getenv('CHOLAPP_DB_NAME') ?: 'cholapp_db';
    $user = getenv('CHOLAPP_DB_USER') ?: 'root';
    $pass = getenv('CHOLAPP_DB_PASS') ?: 'chol_passwd';

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

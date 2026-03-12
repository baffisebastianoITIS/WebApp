<?php
// backend/api/languages.php
require_once __DIR__ . '/../config/database.php';

$stmt = $pdo->query("SELECT id, name, logo_emoji, description FROM languages ORDER BY name");
$languages = $stmt->fetchAll();

jsonResponse(['languages' => $languages]);

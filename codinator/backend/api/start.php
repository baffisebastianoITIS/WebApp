<?php
// backend/api/start.php
require_once __DIR__ . '/../config/database.php';

// Generate session ID
$sessionId = bin2hex(random_bytes(32));

// Initialize session
$stmt = $pdo->prepare("INSERT INTO game_sessions (id, answers_given, status) VALUES (?, '{}', 'active')");
$stmt->execute([$sessionId]);

// Get first question (most discriminating one)
$stmt = $pdo->query("SELECT id, text, category FROM questions ORDER BY id LIMIT 1");
$firstQuestion = $stmt->fetch();

jsonResponse([
    'session_id' => $sessionId,
    'question' => $firstQuestion,
    'question_number' => 1,
    'total_questions' => 25,
    'progress' => 0
]);

<?php
// backend/api/feedback.php
require_once __DIR__ . '/../config/database.php';

$input = json_decode(file_get_contents('php://input'), true);

if (!$input || !isset($input['session_id']) || !isset($input['correct'])) {
    jsonResponse(['error' => 'Missing required parameters'], 400);
}

$sessionId = $input['session_id'];
$correct = (bool)$input['correct'];

$status = $correct ? 'won' : 'lost';

$stmt = $pdo->prepare("UPDATE game_sessions SET status = ? WHERE id = ?");
$stmt->execute([$status, $sessionId]);

if ($correct) {
    jsonResponse(['message' => 'Great! I got it right!', 'status' => 'won']);
} else {
    // If wrong, we can ask what the correct language was
    $correctLanguageId = $input['correct_language_id'] ?? null;
    
    if ($correctLanguageId) {
        $stmt = $pdo->prepare("UPDATE game_sessions SET guessed_language_id = ? WHERE id = ?");
        $stmt->execute([$correctLanguageId, $sessionId]);
    }
    
    jsonResponse(['message' => 'I\'ll learn from this!', 'status' => 'lost']);
}

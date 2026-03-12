<?php
// backend/api/answer.php
require_once __DIR__ . '/../config/database.php';

$input = json_decode(file_get_contents('php://input'), true);

if (!$input || !isset($input['session_id']) || !isset($input['question_id']) || !isset($input['answer'])) {
    jsonResponse(['error' => 'Missing required parameters'], 400);
}

$sessionId = $input['session_id'];
$questionId = (int)$input['question_id'];
$answer = $input['answer']; // 'yes', 'no', 'maybe'

if (!in_array($answer, ['yes', 'no', 'maybe'])) {
    jsonResponse(['error' => 'Invalid answer'], 400);
}

// Get session
$stmt = $pdo->prepare("SELECT * FROM game_sessions WHERE id = ? AND status = 'active'");
$stmt->execute([$sessionId]);
$session = $stmt->fetch();

if (!$session) {
    jsonResponse(['error' => 'Session not found or already ended'], 404);
}

// Update answers
$answersGiven = json_decode($session['answers_given'] ?? '{}', true);
$answersGiven[$questionId] = $answer;

$stmt = $pdo->prepare("UPDATE game_sessions SET answers_given = ? WHERE id = ?");
$stmt->execute([json_encode($answersGiven), $sessionId]);

$questionCount = count($answersGiven);

// ============================================================
// ALGORITHM: Score each language based on given answers
// ============================================================
function scoreLanguages($pdo, $answersGiven) {
    $languages = $pdo->query("SELECT id, name, logo_emoji, description FROM languages")->fetchAll();
    
    $scores = [];
    foreach ($languages as $lang) {
        $score = 100; // Start with 100 points
        
        foreach ($answersGiven as $qId => $userAnswer) {
            // Get what this language would answer to this question
            $stmt = $pdo->prepare("SELECT answer FROM answers WHERE language_id = ? AND question_id = ?");
            $stmt->execute([$lang['id'], $qId]);
            $expectedAnswer = $stmt->fetchColumn();
            
            if ($expectedAnswer === false) continue; // No data for this combo
            
            if ($userAnswer === $expectedAnswer) {
                $score += 15; // Perfect match
            } elseif ($userAnswer === 'maybe' || $expectedAnswer === 'maybe') {
                $score += 5; // Partial match
            } else {
                $score -= 30; // Mismatch penalty
            }
        }
        
        $scores[] = [
            'language' => $lang,
            'score' => $score
        ];
    }
    
    // Sort by score descending
    usort($scores, fn($a, $b) => $b['score'] - $a['score']);
    return $scores;
}

$scores = scoreLanguages($pdo, $answersGiven);
$topScore = $scores[0]['score'];
$secondScore = isset($scores[1]) ? $scores[1]['score'] : 0;

// Decide whether to guess or ask more
$shouldGuess = false;
$reason = '';

if ($questionCount >= 5 && $topScore >= 150 && ($topScore - $secondScore) >= 50) {
    $shouldGuess = true;
    $reason = 'high_confidence';
} elseif ($questionCount >= 10 && ($topScore - $secondScore) >= 35) {
    $shouldGuess = true;
    $reason = 'medium_confidence';
} elseif ($questionCount >= 15) {
    $shouldGuess = true;
    $reason = 'max_questions';
}

if ($shouldGuess) {
    $bestLanguage = $scores[0]['language'];
    
    $stmt = $pdo->prepare("UPDATE game_sessions SET status = 'won', guessed_language_id = ? WHERE id = ?");
    $stmt->execute([$bestLanguage['id'], $sessionId]);
    
    jsonResponse([
        'action' => 'guess',
        'language' => $bestLanguage,
        'confidence' => min(99, max(60, (int)(($topScore / ($topScore + $secondScore + 1)) * 100))),
        'question_number' => $questionCount,
        'reason' => $reason
    ]);
}

// ============================================================
// Find the MOST DISCRIMINATING next question
// ============================================================
$askedQuestions = array_keys($answersGiven);

// Get all unanswered questions
$placeholders = implode(',', array_fill(0, count($askedQuestions), '?'));
$sql = "SELECT id, text, category FROM questions WHERE id NOT IN ($placeholders)";
$stmt = $pdo->prepare($sql);
$stmt->execute($askedQuestions);
$remainingQuestions = $stmt->fetchAll();

if (empty($remainingQuestions)) {
    // No more questions - make best guess
    $bestLanguage = $scores[0]['language'];
    
    $stmt = $pdo->prepare("UPDATE game_sessions SET status = 'won', guessed_language_id = ? WHERE id = ?");
    $stmt->execute([$bestLanguage['id'], $sessionId]);
    
    jsonResponse([
        'action' => 'guess',
        'language' => $bestLanguage,
        'confidence' => 70,
        'question_number' => $questionCount,
        'reason' => 'no_more_questions'
    ]);
}

// Score each remaining question by how much it splits the top candidates
$topCandidates = array_slice($scores, 0, 5); // Consider top 5 candidates

$bestQuestion = null;
$bestDiscrimination = -1;

foreach ($remainingQuestions as $question) {
    $yesCount = 0; $noCount = 0; $maybeCount = 0;
    
    foreach ($topCandidates as $candidate) {
        $stmt = $pdo->prepare("SELECT answer FROM answers WHERE language_id = ? AND question_id = ?");
        $stmt->execute([$candidate['language']['id'], $question['id']]);
        $ans = $stmt->fetchColumn();
        
        if ($ans === 'yes') $yesCount++;
        elseif ($ans === 'no') $noCount++;
        else $maybeCount++;
    }
    
    $total = count($topCandidates);
    // Good discrimination = splits evenly between yes and no
    $discrimination = $yesCount * $noCount; // Maximized when split is 50/50
    
    if ($discrimination > $bestDiscrimination) {
        $bestDiscrimination = $discrimination;
        $bestQuestion = $question;
    }
}

// Fallback to first remaining question
if (!$bestQuestion) {
    $bestQuestion = $remainingQuestions[0];
}

jsonResponse([
    'action' => 'question',
    'question' => $bestQuestion,
    'question_number' => $questionCount + 1,
    'total_questions' => 25,
    'progress' => min(99, (int)($questionCount / 15 * 100)),
    'top_candidates' => array_slice(array_map(fn($s) => [
        'name' => $s['language']['name'],
        'emoji' => $s['language']['logo_emoji'],
        'score' => $s['score']
    ], $scores), 0, 3)
]);

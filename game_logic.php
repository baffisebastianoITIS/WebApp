<?php
session_start();
header('Content-Type: application/json');

$conn = new mysqli("akinator_db", "root", "password_segreta", "akinator_game");

// Se è l'inizio del gioco, resetta i filtri
if (!isset($_GET['answer']) || $_GET['answer'] == 'reset') {
    $_SESSION['step'] = 0;
    $_SESSION['filters'] = [];
}

$domande = [
    ['col' => 'compilato', 'testo' => 'Il linguaggio è compilato?'],
    ['col' => 'tipizzazione_forte', 'testo' => 'Ha una tipizzazione forte?'],
    ['col' => 'web_oriented', 'testo' => 'È orientato al web?']
];

// Se l'utente ha risposto, salva il filtro
if (isset($_GET['answer'])) {
    $last_step = $_SESSION['step'];
    $valore = ($_GET['answer'] == 'si') ? 1 : 0;
    $_SESSION['filters'][$domande[$last_step]['col']] = $valore;
    $_SESSION['step']++;
}

$current_step = $_SESSION['step'];

// Se abbiamo finito le domande, cerchiamo il risultato
if ($current_step >= count($domande)) {
    $sql = "SELECT nome FROM linguaggi WHERE ";
    $condizioni = [];
    foreach ($_SESSION['filters'] as $col => $val) {
        $condizioni[] = "$col = $val";
    }
    $sql .= implode(" AND ", $condizioni) . " LIMIT 1";
    
    $res = $conn->query($sql);
    $row = $res->fetch_assoc();
    $nome = $row ? $row['nome'] : "Sconosciuto (nessun match)";
    
    echo json_encode(["type" => "result", "text" => $nome]);
} else {
    // Altrimenti invia la prossima domanda
    echo json_encode(["type" => "question", "text" => $domande[$current_step]['testo']]);
}
?>

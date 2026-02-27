<?php
session_start();
header('Content-Type: application/json');

// Connessione
$conn = new mysqli("akinator_db", "root", "password_segreta", "akinator_game");

// Definiamo le domande
$domande = [
    ['col' => 'compilato', 'testo' => 'Il linguaggio è compilato?'],
    ['col' => 'tipizzazione_forte', 'testo' => 'Ha una tipizzazione forte?'],
    ['col' => 'web_oriented', 'testo' => 'È orientato al web?']
];

// 1. LOGICA DI RESET: Solo se answer è 'reset' o se la sessione è vuota
if (!isset($_GET['answer']) || $_GET['answer'] == 'reset' || !isset($_SESSION['step'])) {
    $_SESSION['step'] = 0;
    $_SESSION['filters'] = [];
    
    // Se è solo un reset, inviamo la prima domanda e usciamo
    if (isset($_GET['answer']) && $_GET['answer'] == 'reset') {
        echo json_encode(["type" => "question", "text" => $domande[0]['testo']]);
        exit;
    }
}

// 2. LOGICA DI RISPOSTA: Solo se l'utente ha risposto 'si' o 'no'
if (($_GET['answer'] == 'si' || $_GET['answer'] == 'no') && $_SESSION['step'] < count($domande)) {
    $last_step = $_SESSION['step'];
    $valore = ($_GET['answer'] == 'si') ? 1 : 0;
    
    // Salviamo il filtro per la colonna corrispondente
    $colonna = $domande[$last_step]['col'];
    $_SESSION['filters'][$colonna] = $valore;
    
    // Avanziamo alla prossima domanda
    $_SESSION['step']++;
}

$current_step = $_SESSION['step'];

// 3. INVIO RISULTATO O NUOVA DOMANDA
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
    echo json_encode(["type" => "question", "text" => $domande[$current_step]['testo']]);
}
?>

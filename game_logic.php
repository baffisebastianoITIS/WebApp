<?php
header('Content-Type: application/json');

// Connessione al DB (Usa il nome del container!)
$conn = new mysqli("akinator_db", "root", "password_segreta", "akinator_game");

if ($conn->connect_error) {
    die(json_encode(["error" => "Connessione fallita"]));
}

$answer = $_GET['answer'] ?? '';

// QUI ANDREBBE LA TUA LOGICA DI GIOCO
// Per ora facciamo un esempio statico di risposta:
echo json_encode([
    "type" => "question",
    "text" => "Il linguaggio è orientato agli oggetti?"
]);
?>
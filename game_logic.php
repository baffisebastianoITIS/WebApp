<?php
header('Content-Type: application/json');

$conn = new mysqli("akinator_db", "root", "password_segreta", "akinator_game");

// Se non ci sono parametri, non fare nulla
if (empty($_GET)) {
    echo json_encode(["text" => "Nessun dato ricevuto"]);
    exit;
}

// Costruiamo la query in base a quello che ci invia il Javascript
$condizioni = [];
foreach ($_GET as $colonna => $valore) {
    // Pulizia base per sicurezza
    $col = preg_replace('/[^a-z_]/', '', $colonna);
    $val = intval($valore);
    $condizioni[] = "$col = $val";
}

$sql = "SELECT nome FROM linguaggi WHERE " . implode(" AND ", $condizioni) . " LIMIT 1";
$res = $conn->query($sql);
$row = $res->fetch_assoc();

$risultato = $row ? $row['nome'] : "un linguaggio che non conosco ancora!";

echo json_encode(["type" => "result", "text" => $risultato]);
?>

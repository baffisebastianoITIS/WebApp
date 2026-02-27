let currentStep = 0;
let filters = {};

const domande = [
    { col: 'compilato', testo: 'Il linguaggio è compilato?' },
    { col: 'tipizzazione_forte', testo: 'Ha una tipizzazione forte?' },
    { col: 'web_oriented', testo: 'È orientato al web?' }
];

function startGame() {
    currentStep = 0;
    filters = {};
    showQuestion();
}

function showQuestion() {
    document.getElementById('question').innerText = domande[currentStep].testo;
    document.querySelector('.buttons').innerHTML = `
        <button onclick="sendAnswer('si')">SÌ</button>
        <button onclick="sendAnswer('no')">NO</button>
    `;
}

function sendAnswer(val) {
    // Salviamo la risposta localmente
    filters[domande[currentStep].col] = (val === 'si' ? 1 : 0);
    currentStep++;

    if (currentStep < domande.length) {
        showQuestion();
    } else {
        getFinalResult();
    }
}

function getFinalResult() {
    // Mandiamo tutti i filtri insieme al PHP alla fine
    const params = new URLSearchParams(filters).toString();
    fetch('game_logic.php?' + params)
        .then(res => res.json())
        .then(data => {
            document.getElementById('question').innerHTML = "Ho indovinato! È <strong>" + data.text + "</strong>!";
            document.querySelector('.buttons').innerHTML = '<button onclick="startGame()">Gioca ancora</button>';
        });
}

function startGame() {
    document.getElementById('question').innerText = "Il linguaggio è compilato?";
    const btnContainer = document.querySelector('.buttons');
    btnContainer.innerHTML = `
        <button onclick="sendAnswer('si')">SÌ</button>
        <button onclick="sendAnswer('no')">NO</button>
    `;
}

function sendAnswer(val) {
    console.log("Risposta inviata: " + val);
    // Qui andrà la chiamata AJAX a un file PHP per interrogare il DB
}
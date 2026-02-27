function startGame() {
    document.getElementById('question').innerText = "Il linguaggio è compilato?";
    const btnContainer = document.querySelector('.buttons');
    btnContainer.innerHTML = `
        <button onclick="sendAnswer('si')">SÌ</button>
        <button onclick="sendAnswer('no')">NO</button>
    `;
}

function sendAnswer(val) {
    fetch('game_logic.php?answer=' + val)
        .then(response => response.json())
        .then(data => {
            if (data.type === 'question') {
                document.getElementById('question').innerText = data.text;
            } else if (data.type === 'result') {
                document.getElementById('question').innerHTML = "Ho indovinato! È <strong>" + data.text + "</strong>!";
                document.querySelector('.buttons').innerHTML = '<button onclick="location.reload()">Gioca ancora</button>';
            }
        })
        .catch(error => console.error('Errore:', error));
}

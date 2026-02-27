function startGame() {
    document.getElementById('question').innerText = "Il linguaggio è compilato?";
    const btnContainer = document.querySelector('.buttons');
    btnContainer.innerHTML = `
        <button onclick="sendAnswer('si')">SÌ</button>
        <button onclick="sendAnswer('no')">NO</button>
    `;
}

function startGame() {
    // Chiamiamo il PHP con 'reset' per pulire la sessione
    fetch('game_logic.php?answer=reset')
        .then(response => response.json())
        .then(data => {
            document.getElementById('question').innerText = data.text;
            const btnContainer = document.querySelector('.buttons');
            btnContainer.innerHTML = `
                <button onclick="sendAnswer('si')">SÌ</button>
                <button onclick="sendAnswer('no')">NO</button>
            `;
        });
}

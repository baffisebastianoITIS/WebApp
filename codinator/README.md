# 🧞 CODINATOR

> Clone di Akinator per linguaggi di programmazione — Indovina il linguaggio a cui stai pensando!

![Stack](https://img.shields.io/badge/Stack-PHP%20%7C%20MySQL%20%7C%20JS%20%7C%20Tailwind-C8FF00?style=flat-square&labelColor=090B0F)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=flat-square&logo=docker)

---

## 🚀 Avvio Rapido

### Con Docker (consigliato)

```bash
# Clona il repo
git clone https://github.com/tuousername/codinator
cd codinator

# Avvia i container
docker compose up --build

# Apri nel browser
# → http://localhost:8080
# → http://localhost:8081 (phpMyAdmin)
```

### GitHub Codespaces

1. Apri il repo su GitHub
2. Clicca **Code → Codespaces → Create codespace on main**
3. Aspetta l'avvio e poi esegui:
   ```bash
   docker compose up --build
   ```
4. Clicca sul link della porta `8080` nel pannello Ports

---

## 📂 Struttura del Progetto

```
codinator/
├── docker-compose.yml          # Orchestrazione Docker
├── docker/
│   ├── Dockerfile.php          # Container PHP/Apache
│   └── apache.conf             # Configurazione Apache
├── frontend/
│   ├── index.html              # Pagina principale
│   ├── css/
│   │   └── style.css           # Stili custom
│   └── js/
│       └── game.js             # Logica di gioco
├── backend/
│   ├── config/
│   │   └── database.php        # Connessione PDO + helpers
│   └── api/
│       ├── start.php           # POST /api/start.php — Avvia sessione
│       ├── answer.php          # POST /api/answer.php — Risposta + prossima domanda
│       ├── feedback.php        # POST /api/feedback.php — Conferma/nega ipotesi
│       └── languages.php       # GET  /api/languages.php — Lista linguaggi
└── database/
    └── init.sql                # Schema + dati iniziali (20 linguaggi, 25 domande)
```

---

## 🧠 Come Funziona l'Algoritmo

1. **Scoring**: Ogni linguaggio parte con 100 punti
2. **Match**: +15 punti se la risposta coincide, +5 per "forse", -30 per mismatch
3. **Discriminazione**: La prossima domanda è quella che meglio separa i candidati principali
4. **Ipotesi**: Viene fatta un'ipotesi quando il punteggio top è sufficientemente distaccato dal secondo, oppure dopo un massimo di domande

---

## 🗄️ Schema Database

| Tabella | Descrizione |
|---------|-------------|
| `languages` | 20 linguaggi di programmazione |
| `questions` | 25 domande categorizzate |
| `answers` | Matrice linguaggio × domanda (yes/no/maybe) |
| `game_sessions` | Sessioni di gioco con storico risposte |

---

## 🎮 Linguaggi Supportati

🐍 Python · 🟨 JavaScript · ☕ Java · ⚙️ C · 🔧 C++ · 🎯 C# · 🐘 PHP · 💎 Ruby  
🐹 Go · 🦀 Rust · 🐦 Swift · 🎪 Kotlin · 🔷 TypeScript · 📊 R · 🔴 Scala  
🔮 Haskell · 🌙 Lua · 🐪 Perl · 🗄️ SQL · 🔩 Assembly

---

## ⌨️ Shortcut da Tastiera

| Tasto | Azione |
|-------|--------|
| `Y` o `1` | Sì |
| `M` o `2` | Forse |
| `N` o `3` | No |

---

## 🔌 API Reference

### `POST /api/start.php`
Avvia una nuova sessione di gioco.

**Response:**
```json
{
  "session_id": "abc123...",
  "question": { "id": 1, "text": "...", "category": "compilation" },
  "question_number": 1
}
```

### `POST /api/answer.php`
Invia una risposta e riceve la prossima domanda o un'ipotesi.

**Body:**
```json
{ "session_id": "abc123", "question_id": 1, "answer": "yes" }
```

**Response (domanda):**
```json
{ "action": "question", "question": {...}, "question_number": 2, "progress": 12 }
```

**Response (ipotesi):**
```json
{ "action": "guess", "language": { "name": "Python", "logo_emoji": "🐍" }, "confidence": 94 }
```

### `POST /api/feedback.php`
Conferma se l'ipotesi è corretta.

```json
{ "session_id": "abc123", "correct": true }
```

### `GET /api/languages.php`
Restituisce tutti i linguaggi disponibili.

---

## 🛠️ Tech Stack

- **Frontend**: HTML5, Vanilla JS, Tailwind CSS, CSS3 Animations
- **Backend**: PHP 8.2, PDO
- **Database**: MySQL 8.0
- **DevOps**: Docker, Docker Compose, Apache 2
- **Font**: Space Mono, Syne (Google Fonts)

---

## 📝 Licenza

MIT — Sentiti libero di fare fork e migliorare!

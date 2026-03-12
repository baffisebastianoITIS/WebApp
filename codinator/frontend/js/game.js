// ============================================================
// CODINATOR - Game Logic
// ============================================================

const API_BASE = '/api';

const categoryLabels = {
  compilation: '⚡ Compilazione',
  usage: '🎯 Utilizzo',
  paradigm: '🧩 Paradigma',
  memory: '🧠 Gestione Memoria',
  typing: '✍️ Tipizzazione',
  origin: '🏢 Origine',
  age: '📅 Età',
  runtime: '⚙️ Runtime',
  level: '📊 Livello',
  syntax: '📝 Sintassi',
  difficulty: '🎓 Difficoltà',
  ecosystem: '📦 Ecosistema',
  features: '🔮 Funzionalità',
  general: '💡 Generale',
};

// ============================================================
// STATE
// ============================================================
const state = {
  sessionId: null,
  currentQuestion: null,
  questionNumber: 0,
  guessedLanguage: null,
  allLanguages: [],
};

// ============================================================
// DOM REFERENCES
// ============================================================
const screens = {
  home: document.getElementById('screen-home'),
  game: document.getElementById('screen-game'),
  guess: document.getElementById('screen-guess'),
  win: document.getElementById('screen-win'),
  lose: document.getElementById('screen-lose'),
};

const els = {
  btnStart: document.getElementById('btn-start'),
  btnRestartGame: document.getElementById('btn-restart-game'),
  questionText: document.getElementById('question-text'),
  questionCategory: document.getElementById('question-category'),
  questionCounter: document.getElementById('question-counter'),
  progressBar: document.getElementById('progress-bar'),
  thinkingBar: document.getElementById('thinking-bar'),
  questionCard: document.getElementById('question-card'),
  answerButtons: document.getElementById('answer-buttons'),
  candidatesPanel: document.getElementById('candidates-panel'),
  candidatesList: document.getElementById('candidates-list'),
  guessEmoji: document.getElementById('guess-emoji'),
  guessName: document.getElementById('guess-name'),
  guessDescription: document.getElementById('guess-description'),
  guessConfidence: document.getElementById('guess-confidence'),
  btnCorrect: document.getElementById('btn-correct'),
  btnWrong: document.getElementById('btn-wrong'),
  winLanguageName: document.getElementById('win-language-name'),
  winEmoji: document.getElementById('win-emoji'),
  winName: document.getElementById('win-name'),
  winQuestionsCount: document.getElementById('win-questions-count'),
  btnPlayAgainWin: document.getElementById('btn-play-again-win'),
  btnPlayAgainLose: document.getElementById('btn-play-again-lose'),
  correctLanguageSelect: document.getElementById('correct-language-select'),
  btnSubmitCorrection: document.getElementById('btn-submit-correction'),
  loadingOverlay: document.getElementById('loading-overlay'),
};

// ============================================================
// SCREEN MANAGEMENT
// ============================================================
function showScreen(name) {
  Object.entries(screens).forEach(([key, el]) => {
    if (key === name) {
      el.classList.remove('hidden');
    } else {
      el.classList.add('hidden');
    }
  });
}

// ============================================================
// API CALLS
// ============================================================
async function apiCall(endpoint, method = 'GET', body = null) {
  const options = {
    method,
    headers: { 'Content-Type': 'application/json' },
  };
  if (body) options.body = JSON.stringify(body);

  try {
    const response = await fetch(`${API_BASE}/${endpoint}`, options);
    const data = await response.json();
    if (!response.ok) throw new Error(data.error || 'API error');
    return data;
  } catch (err) {
    console.error(`API error [${endpoint}]:`, err);
    throw err;
  }
}

// ============================================================
// GAME FLOW
// ============================================================
async function startGame() {
  showLoading(true);
  try {
    const data = await apiCall('start.php');
    state.sessionId = data.session_id;
    state.questionNumber = 1;

    showScreen('game');
    displayQuestion(data.question, 1, 0);
  } catch (err) {
    alert('Errore di connessione. Assicurati che il server sia attivo.');
  } finally {
    showLoading(false);
  }
}

function displayQuestion(question, number, progress) {
  state.currentQuestion = question;
  state.questionNumber = number;

  // Animate out
  els.questionCard.classList.add('transitioning');

  setTimeout(() => {
    els.questionText.textContent = question.text;
    els.questionCategory.textContent = categoryLabels[question.category] || '💡 Generale';
    els.questionCounter.textContent = `Domanda ${number}`;
    els.progressBar.style.width = `${progress}%`;

    // Animate in
    els.questionCard.classList.remove('transitioning');
    enableAnswerButtons();
  }, 200);
}

async function submitAnswer(answer) {
  disableAnswerButtons();
  showThinking(true);

  try {
    const data = await apiCall('answer.php', 'POST', {
      session_id: state.sessionId,
      question_id: state.currentQuestion.id,
      answer: answer,
    });

    showThinking(false);

    if (data.action === 'question') {
      // Update candidates panel
      if (data.top_candidates && data.top_candidates.length > 0) {
        updateCandidates(data.top_candidates);
      }
      displayQuestion(data.question, data.question_number, data.progress);

    } else if (data.action === 'guess') {
      showGuess(data.language, data.confidence, data.question_number);
    }

  } catch (err) {
    showThinking(false);
    alert('Errore nella comunicazione con il server.');
    enableAnswerButtons();
  }
}

function showGuess(language, confidence, questionNum) {
  state.guessedLanguage = language;
  state.questionNumber = questionNum;

  els.guessEmoji.textContent = language.logo_emoji;
  els.guessName.textContent = language.name;
  els.guessDescription.textContent = language.description;
  els.guessConfidence.textContent = `${confidence}%`;

  // Genie gets excited
  document.getElementById('guess-genie').textContent = '🧞‍♂️';

  showScreen('guess');
}

async function handleCorrect() {
  await apiCall('feedback.php', 'POST', {
    session_id: state.sessionId,
    correct: true,
  });

  // Show win screen
  const lang = state.guessedLanguage;
  els.winLanguageName.textContent = lang.name;
  els.winEmoji.textContent = lang.logo_emoji;
  els.winName.textContent = lang.name;
  els.winQuestionsCount.textContent = `in ${state.questionNumber} domande`;

  showScreen('win');
}

async function handleWrong() {
  await apiCall('feedback.php', 'POST', {
    session_id: state.sessionId,
    correct: false,
  });

  // Populate language select
  populateLanguageSelect();
  showScreen('lose');
}

async function submitCorrection() {
  const languageId = els.correctLanguageSelect.value;
  if (!languageId) {
    els.correctLanguageSelect.style.borderColor = '#FF4444';
    setTimeout(() => { els.correctLanguageSelect.style.borderColor = ''; }, 1500);
    return;
  }

  await apiCall('feedback.php', 'POST', {
    session_id: state.sessionId,
    correct: false,
    correct_language_id: parseInt(languageId),
  });

  resetAndGoHome();
}

// ============================================================
// UI HELPERS
// ============================================================
function disableAnswerButtons() {
  document.querySelectorAll('.answer-btn').forEach(btn => {
    btn.disabled = true;
    btn.style.opacity = '0.5';
    btn.style.cursor = 'not-allowed';
  });
}

function enableAnswerButtons() {
  document.querySelectorAll('.answer-btn').forEach(btn => {
    btn.disabled = false;
    btn.style.opacity = '';
    btn.style.cursor = '';
  });
}

function showThinking(show) {
  els.thinkingBar.classList.toggle('hidden', !show);
}

function showLoading(show) {
  els.loadingOverlay.classList.toggle('hidden', !show);
}

function updateCandidates(candidates) {
  els.candidatesPanel.classList.remove('hidden');
  els.candidatesList.innerHTML = '';

  candidates.forEach(c => {
    const chip = document.createElement('div');
    chip.className = 'candidate-chip';
    chip.innerHTML = `${c.emoji} ${c.name}`;
    els.candidatesList.appendChild(chip);
  });
}

function populateLanguageSelect() {
  els.correctLanguageSelect.innerHTML = '<option value="">Seleziona il linguaggio...</option>';
  state.allLanguages.forEach(lang => {
    const opt = document.createElement('option');
    opt.value = lang.id;
    opt.textContent = `${lang.logo_emoji} ${lang.name}`;
    els.correctLanguageSelect.appendChild(opt);
  });
}

async function loadLanguages() {
  try {
    const data = await apiCall('languages.php');
    state.allLanguages = data.languages || [];
  } catch (err) {
    console.error('Could not load languages:', err);
  }
}

function resetAndGoHome() {
  state.sessionId = null;
  state.currentQuestion = null;
  state.questionNumber = 0;
  state.guessedLanguage = null;
  els.candidatesPanel.classList.add('hidden');
  els.progressBar.style.width = '0%';
  showScreen('home');
}

// ============================================================
// EVENT LISTENERS
// ============================================================
els.btnStart.addEventListener('click', startGame);
els.btnRestartGame.addEventListener('click', resetAndGoHome);
els.btnCorrect.addEventListener('click', handleCorrect);
els.btnWrong.addEventListener('click', handleWrong);
els.btnSubmitCorrection.addEventListener('click', submitCorrection);
els.btnPlayAgainWin.addEventListener('click', startGame);
els.btnPlayAgainLose.addEventListener('click', () => {
  resetAndGoHome();
  setTimeout(startGame, 100);
});

// Answer buttons
document.querySelectorAll('.answer-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    const answer = btn.getAttribute('data-answer');

    // Visual feedback
    btn.style.transform = 'scale(0.9)';
    setTimeout(() => { btn.style.transform = ''; }, 150);

    submitAnswer(answer);
  });
});

// Keyboard shortcuts
document.addEventListener('keydown', (e) => {
  if (screens.game.classList.contains('hidden')) return;
  
  const map = { 'y': 'yes', 'n': 'no', 'm': 'maybe', '1': 'yes', '2': 'maybe', '3': 'no' };
  const answer = map[e.key.toLowerCase()];
  
  if (answer) {
    const btn = document.querySelector(`.answer-btn[data-answer="${answer}"]`);
    if (btn && !btn.disabled) btn.click();
  }
});

// ============================================================
// INIT
// ============================================================
(async function init() {
  await loadLanguages();
  showScreen('home');
  
  console.log('%c CODINATOR 🧞 ', 
    'background: #C8FF00; color: #090B0F; font-family: monospace; font-size: 16px; font-weight: bold; padding: 4px 8px;'
  );
  console.log('%cTasto Y = Sì | M = Forse | N = No', 'color: #8899AA; font-family: monospace;');
})();

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ============================================================
-- CODINATOR - Database Init
-- Clone di Akinator per linguaggi di programmazione
-- ============================================================

CREATE DATABASE IF NOT EXISTS codinator;
USE codinator;

-- ============================================================
-- LINGUAGGI DI PROGRAMMAZIONE
-- ============================================================
CREATE TABLE IF NOT EXISTS languages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    logo_emoji VARCHAR(10) DEFAULT '💻',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- DOMANDE
-- ============================================================
CREATE TABLE IF NOT EXISTS questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    text TEXT NOT NULL,
    category VARCHAR(50) DEFAULT 'general',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- RISPOSTE (quale linguaggio risponde cosa a quale domanda)
-- ============================================================
CREATE TABLE IF NOT EXISTS answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    language_id INT NOT NULL,
    question_id INT NOT NULL,
    answer ENUM('yes', 'no', 'maybe') NOT NULL,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    UNIQUE KEY unique_lang_question (language_id, question_id)
);

-- ============================================================
-- SESSIONI DI GIOCO
-- ============================================================
CREATE TABLE IF NOT EXISTS game_sessions (
    id VARCHAR(64) PRIMARY KEY,
    answers_given JSON DEFAULT NULL,
    current_question_id INT DEFAULT NULL,
    guessed_language_id INT DEFAULT NULL,
    status ENUM('active', 'won', 'lost') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- INSERIMENTO LINGUAGGI
-- ============================================================
INSERT INTO languages (name, logo_emoji, description) VALUES
('Python', '🐍', 'Linguaggio interpretato, alto livello, multiparadigma'),
('JavaScript', '🟨', 'Linguaggio del web, dinamico, event-driven'),
('Java', '☕', 'Linguaggio compilato, orientato agli oggetti, JVM'),
('C', '⚙️', 'Linguaggio di sistema, basso livello, compilato'),
('C++', '🔧', 'Estensione di C con OOP, basso livello, compilato'),
('C#', '🎯', 'Linguaggio Microsoft, .NET, orientato agli oggetti'),
('PHP', '🐘', 'Linguaggio server-side per il web, interpretato'),
('Ruby', '💎', 'Linguaggio interpretato, elegante, Rails'),
('Go', '🐹', 'Linguaggio compilato Google, concorrenza, veloce'),
('Rust', '🦀', 'Linguaggio di sistema, sicurezza della memoria, compilato'),
('Swift', '🐦', 'Linguaggio Apple, iOS/macOS, compilato'),
('Kotlin', '🎪', 'Linguaggio JVM, Android, moderno'),
('TypeScript', '🔷', 'Superset di JavaScript con tipizzazione statica'),
('R', '📊', 'Linguaggio statistico, data science, interpretato'),
('Scala', '🔴', 'Linguaggio JVM, funzionale e OOP'),
('Haskell', '🔮', 'Linguaggio puramente funzionale, tipizzazione forte'),
('Lua', '🌙', 'Linguaggio leggero, embeddable, scripting'),
('Perl', '🐪', 'Linguaggio di scripting, manipolazione testi'),
('SQL', '🗄️', 'Linguaggio per database, dichiarativo, query'),
('Assembly', '🔩', 'Linguaggio di basso livello, vicino all hardware');

-- ============================================================
-- INSERIMENTO DOMANDE
-- ============================================================
INSERT INTO questions (text, category) VALUES
('È un linguaggio compilato?', 'compilation'),
('È un linguaggio interpretato?', 'compilation'),
('È principalmente usato per lo sviluppo web?', 'usage'),
('È usato per lo sviluppo mobile?', 'usage'),
('È usato per la data science o il machine learning?', 'usage'),
('È un linguaggio orientato agli oggetti?', 'paradigm'),
('Supporta la programmazione funzionale?', 'paradigm'),
('È un linguaggio di basso livello (vicino all''hardware)?', 'level'),
('Gestisce automaticamente la memoria (garbage collector)?', 'memory'),
('Ha una tipizzazione statica (i tipi si dichiarano)?', 'typing'),
('È sviluppato da una grande azienda tecnologica?', 'origin'),
('Esiste dagli anni ''90 o prima?', 'age'),
('È comunemente usato per scripting o automazione?', 'usage'),
('Gira sulla Java Virtual Machine (JVM)?', 'runtime'),
('È principalmente usato per sistemi operativi o driver?', 'usage'),
('Ha una sintassi molto simile a C?', 'syntax'),
('È considerato facile da imparare per i principianti?', 'difficulty'),
('Ha un forte ecosistema di package/librerie?', 'ecosystem'),
('Supporta la concorrenza o il parallelismo nativamente?', 'features'),
('È usato nello sviluppo di videogiochi?', 'usage'),
('Ha una sintassi basata sull''indentazione?', 'syntax'),
('È puramente funzionale (senza stato mutabile)?', 'paradigm'),
('È usato principalmente nei database?', 'usage'),
('È un linguaggio di scripting embedded in altri programmi?', 'usage'),
('Garantisce la sicurezza della memoria a compile time?', 'memory');

-- ============================================================
-- RISPOSTE PER OGNI LINGUAGGIO
-- Format: (language_id, question_id, answer)
-- Q1=compilato, Q2=interpretato, Q3=web, Q4=mobile, Q5=data science
-- Q6=OOP, Q7=funzionale, Q8=basso livello, Q9=GC, Q10=tipiz. statica
-- Q11=grande azienda, Q12=anni90+, Q13=scripting, Q14=JVM, Q15=OS/driver
-- Q16=sintassi C, Q17=facile, Q18=ecosistema, Q19=concorrenza, Q20=games
-- Q21=indentazione, Q22=puramente funzionale, Q23=database, Q24=embedded, Q25=mem safety
-- ============================================================

-- Python (id=1)
INSERT INTO answers (language_id, question_id, answer) VALUES
(1,1,'no'),(1,2,'yes'),(1,3,'maybe'),(1,4,'maybe'),(1,5,'yes'),
(1,6,'yes'),(1,7,'yes'),(1,8,'no'),(1,9,'yes'),(1,10,'no'),
(1,11,'no'),(1,12,'no'),(1,13,'yes'),(1,14,'no'),(1,15,'no'),
(1,16,'no'),(1,17,'yes'),(1,18,'yes'),(1,19,'maybe'),(1,20,'maybe'),
(1,21,'yes'),(1,22,'no'),(1,23,'no'),(1,24,'no'),(1,25,'no');

-- JavaScript (id=2)
INSERT INTO answers (language_id, question_id, answer) VALUES
(2,1,'no'),(2,2,'yes'),(2,3,'yes'),(2,4,'maybe'),(2,5,'maybe'),
(2,6,'yes'),(2,7,'yes'),(2,8,'no'),(2,9,'yes'),(2,10,'no'),
(2,11,'no'),(2,12,'yes'),(2,13,'yes'),(2,14,'no'),(2,15,'no'),
(2,16,'maybe'),(2,17,'maybe'),(2,18,'yes'),(2,19,'maybe'),(2,20,'maybe'),
(2,21,'no'),(2,22,'no'),(2,23,'no'),(2,24,'no'),(2,25,'no');

-- Java (id=3)
INSERT INTO answers (language_id, question_id, answer) VALUES
(3,1,'yes'),(3,2,'no'),(3,3,'maybe'),(3,4,'yes'),(3,5,'maybe'),
(3,6,'yes'),(3,7,'maybe'),(3,8,'no'),(3,9,'yes'),(3,10,'yes'),
(3,11,'yes'),(3,12,'yes'),(3,13,'no'),(3,14,'yes'),(3,15,'no'),
(3,16,'yes'),(3,17,'no'),(3,18,'yes'),(3,19,'maybe'),(3,20,'maybe'),
(3,21,'no'),(3,22,'no'),(3,23,'no'),(3,24,'no'),(3,25,'no');

-- C (id=4)
INSERT INTO answers (language_id, question_id, answer) VALUES
(4,1,'yes'),(4,2,'no'),(4,3,'no'),(4,4,'no'),(4,5,'no'),
(4,6,'no'),(4,7,'no'),(4,8,'yes'),(4,9,'no'),(4,10,'yes'),
(4,11,'no'),(4,12,'yes'),(4,13,'maybe'),(4,14,'no'),(4,15,'yes'),
(4,16,'yes'),(4,17,'no'),(4,18,'maybe'),(4,19,'no'),(4,20,'yes'),
(4,21,'no'),(4,22,'no'),(4,23,'no'),(4,24,'maybe'),(4,25,'no');

-- C++ (id=5)
INSERT INTO answers (language_id, question_id, answer) VALUES
(5,1,'yes'),(5,2,'no'),(5,3,'no'),(5,4,'no'),(5,5,'no'),
(5,6,'yes'),(5,7,'maybe'),(5,8,'yes'),(5,9,'no'),(5,10,'yes'),
(5,11,'no'),(5,12,'yes'),(5,13,'no'),(5,14,'no'),(5,15,'yes'),
(5,16,'yes'),(5,17,'no'),(5,18,'yes'),(5,19,'maybe'),(5,20,'yes'),
(5,21,'no'),(5,22,'no'),(5,23,'no'),(5,24,'maybe'),(5,25,'no');

-- C# (id=6)
INSERT INTO answers (language_id, question_id, answer) VALUES
(6,1,'yes'),(6,2,'no'),(6,3,'maybe'),(6,4,'yes'),(6,5,'maybe'),
(6,6,'yes'),(6,7,'maybe'),(6,8,'no'),(6,9,'yes'),(6,10,'yes'),
(6,11,'yes'),(6,12,'no'),(6,13,'no'),(6,14,'no'),(6,15,'no'),
(6,16,'yes'),(6,17,'maybe'),(6,18,'yes'),(6,19,'maybe'),(6,20,'yes'),
(6,21,'no'),(6,22,'no'),(6,23,'no'),(6,24,'no'),(6,25,'no');

-- PHP (id=7)
INSERT INTO answers (language_id, question_id, answer) VALUES
(7,1,'no'),(7,2,'yes'),(7,3,'yes'),(7,4,'no'),(7,5,'no'),
(7,6,'yes'),(7,7,'maybe'),(7,8,'no'),(7,9,'yes'),(7,10,'no'),
(7,11,'no'),(7,12,'yes'),(7,13,'yes'),(7,14,'no'),(7,15,'no'),
(7,16,'yes'),(7,17,'maybe'),(7,18,'yes'),(7,19,'no'),(7,20,'no'),
(7,21,'no'),(7,22,'no'),(7,23,'no'),(7,24,'no'),(7,25,'no');

-- Ruby (id=8)
INSERT INTO answers (language_id, question_id, answer) VALUES
(8,1,'no'),(8,2,'yes'),(8,3,'yes'),(8,4,'no'),(8,5,'maybe'),
(8,6,'yes'),(8,7,'yes'),(8,8,'no'),(8,9,'yes'),(8,10,'no'),
(8,11,'no'),(8,12,'yes'),(8,13,'yes'),(8,14,'no'),(8,15,'no'),
(8,16,'no'),(8,17,'yes'),(8,18,'yes'),(8,19,'no'),(8,20,'no'),
(8,21,'no'),(8,22,'no'),(8,23,'no'),(8,24,'no'),(8,25,'no');

-- Go (id=9)
INSERT INTO answers (language_id, question_id, answer) VALUES
(9,1,'yes'),(9,2,'no'),(9,3,'maybe'),(9,4,'no'),(9,5,'no'),
(9,6,'maybe'),(9,7,'maybe'),(9,8,'no'),(9,9,'yes'),(9,10,'yes'),
(9,11,'yes'),(9,12,'no'),(9,13,'yes'),(9,14,'no'),(9,15,'no'),
(9,16,'maybe'),(9,17,'maybe'),(9,18,'yes'),(9,19,'yes'),(9,20,'no'),
(9,21,'no'),(9,22,'no'),(9,23,'no'),(9,24,'no'),(9,25,'no');

-- Rust (id=10)
INSERT INTO answers (language_id, question_id, answer) VALUES
(10,1,'yes'),(10,2,'no'),(10,3,'no'),(10,4,'no'),(10,5,'no'),
(10,6,'maybe'),(10,7,'yes'),(10,8,'yes'),(10,9,'no'),(10,10,'yes'),
(10,11,'no'),(10,12,'no'),(10,13,'no'),(10,14,'no'),(10,15,'yes'),
(10,16,'maybe'),(10,17,'no'),(10,18,'yes'),(10,19,'yes'),(10,20,'yes'),
(10,21,'no'),(10,22,'no'),(10,23,'no'),(10,24,'no'),(10,25,'yes');

-- Swift (id=11)
INSERT INTO answers (language_id, question_id, answer) VALUES
(11,1,'yes'),(11,2,'no'),(11,3,'no'),(11,4,'yes'),(11,5,'no'),
(11,6,'yes'),(11,7,'yes'),(11,8,'no'),(11,9,'yes'),(11,10,'yes'),
(11,11,'yes'),(11,12,'no'),(11,13,'no'),(11,14,'no'),(11,15,'no'),
(11,16,'maybe'),(11,17,'maybe'),(11,18,'yes'),(11,19,'maybe'),(11,20,'maybe'),
(11,21,'no'),(11,22,'no'),(11,23,'no'),(11,24,'no'),(11,25,'maybe');

-- Kotlin (id=12)
INSERT INTO answers (language_id, question_id, answer) VALUES
(12,1,'yes'),(12,2,'no'),(12,3,'maybe'),(12,4,'yes'),(12,5,'no'),
(12,6,'yes'),(12,7,'yes'),(12,8,'no'),(12,9,'yes'),(12,10,'yes'),
(12,11,'yes'),(12,12,'no'),(12,13,'no'),(12,14,'yes'),(12,15,'no'),
(12,16,'no'),(12,17,'maybe'),(12,18,'yes'),(12,19,'maybe'),(12,20,'no'),
(12,21,'no'),(12,22,'no'),(12,23,'no'),(12,24,'no'),(12,25,'no');

-- TypeScript (id=13)
INSERT INTO answers (language_id, question_id, answer) VALUES
(13,1,'no'),(13,2,'yes'),(13,3,'yes'),(13,4,'maybe'),(13,5,'maybe'),
(13,6,'yes'),(13,7,'yes'),(13,8,'no'),(13,9,'yes'),(13,10,'yes'),
(13,11,'yes'),(13,12,'no'),(13,13,'yes'),(13,14,'no'),(13,15,'no'),
(13,16,'maybe'),(13,17,'maybe'),(13,18,'yes'),(13,19,'maybe'),(13,20,'no'),
(13,21,'no'),(13,22,'no'),(13,23,'no'),(13,24,'no'),(13,25,'no');

-- R (id=14)
INSERT INTO answers (language_id, question_id, answer) VALUES
(14,1,'no'),(14,2,'yes'),(14,3,'no'),(14,4,'no'),(14,5,'yes'),
(14,6,'maybe'),(14,7,'yes'),(14,8,'no'),(14,9,'yes'),(14,10,'no'),
(14,11,'no'),(14,12,'yes'),(14,13,'yes'),(14,14,'no'),(14,15,'no'),
(14,16,'no'),(14,17,'no'),(14,18,'yes'),(14,19,'no'),(14,20,'no'),
(14,21,'no'),(14,22,'no'),(14,23,'no'),(14,24,'no'),(14,25,'no');

-- Scala (id=15)
INSERT INTO answers (language_id, question_id, answer) VALUES
(15,1,'yes'),(15,2,'no'),(15,3,'maybe'),(15,4,'no'),(15,5,'maybe'),
(15,6,'yes'),(15,7,'yes'),(15,8,'no'),(15,9,'yes'),(15,10,'yes'),
(15,11,'no'),(15,12,'no'),(15,13,'no'),(15,14,'yes'),(15,15,'no'),
(15,16,'no'),(15,17,'no'),(15,18,'yes'),(15,19,'yes'),(15,20,'no'),
(15,21,'no'),(15,22,'maybe'),(15,23,'no'),(15,24,'no'),(15,25,'no');

-- Haskell (id=16)
INSERT INTO answers (language_id, question_id, answer) VALUES
(16,1,'yes'),(16,2,'no'),(16,3,'no'),(16,4,'no'),(16,5,'maybe'),
(16,6,'no'),(16,7,'yes'),(16,8,'no'),(16,9,'yes'),(16,10,'yes'),
(16,11,'no'),(16,12,'yes'),(16,13,'no'),(16,14,'no'),(16,15,'no'),
(16,16,'no'),(16,17,'no'),(16,18,'maybe'),(16,19,'maybe'),(16,20,'no'),
(16,21,'yes'),(16,22,'yes'),(16,23,'no'),(16,24,'no'),(16,25,'no');

-- Lua (id=17)
INSERT INTO answers (language_id, question_id, answer) VALUES
(17,1,'no'),(17,2,'yes'),(17,3,'no'),(17,4,'no'),(17,5,'no'),
(17,6,'maybe'),(17,7,'yes'),(17,8,'no'),(17,9,'yes'),(17,10,'no'),
(17,11,'no'),(17,12,'yes'),(17,13,'yes'),(17,14,'no'),(17,15,'no'),
(17,16,'no'),(17,17,'yes'),(17,18,'no'),(17,19,'no'),(17,20,'yes'),
(17,21,'no'),(17,22,'no'),(17,23,'no'),(17,24,'yes'),(17,25,'no');

-- Perl (id=18)
INSERT INTO answers (language_id, question_id, answer) VALUES
(18,1,'no'),(18,2,'yes'),(18,3,'maybe'),(18,4,'no'),(18,5,'no'),
(18,6,'maybe'),(18,7,'maybe'),(18,8,'no'),(18,9,'yes'),(18,10,'no'),
(18,11,'no'),(18,12,'yes'),(18,13,'yes'),(18,14,'no'),(18,15,'no'),
(18,16,'no'),(18,17,'no'),(18,18,'maybe'),(18,19,'no'),(18,20,'no'),
(18,21,'no'),(18,22,'no'),(18,23,'no'),(18,24,'no'),(18,25,'no');

-- SQL (id=19)
INSERT INTO answers (language_id, question_id, answer) VALUES
(19,1,'no'),(19,2,'yes'),(19,3,'maybe'),(19,4,'no'),(19,5,'maybe'),
(19,6,'no'),(19,7,'no'),(19,8,'no'),(19,9,'yes'),(19,10,'no'),
(19,11,'no'),(19,12,'yes'),(19,13,'no'),(19,14,'no'),(19,15,'no'),
(19,16,'no'),(19,17,'maybe'),(19,18,'yes'),(19,19,'no'),(19,20,'no'),
(19,21,'no'),(19,22,'no'),(19,23,'yes'),(19,24,'no'),(19,25,'no');

-- Assembly (id=20)
INSERT INTO answers (language_id, question_id, answer) VALUES
(20,1,'yes'),(20,2,'no'),(20,3,'no'),(20,4,'no'),(20,5,'no'),
(20,6,'no'),(20,7,'no'),(20,8,'yes'),(20,9,'no'),(20,10,'yes'),
(20,11,'no'),(20,12,'yes'),(20,13,'no'),(20,14,'no'),(20,15,'yes'),
(20,16,'no'),(20,17,'no'),(20,18,'no'),(20,19,'no'),(20,20,'no'),
(20,21,'no'),(20,22,'no'),(20,23,'no'),(20,24,'no'),(20,25,'yes');

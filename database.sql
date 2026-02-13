CREATE TABLE IF NOT EXISTS linguaggi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    compilato BOOLEAN,
    tipizzazione_forte BOOLEAN,
    web_oriented BOOLEAN
);

INSERT INTO linguaggi (nome, compilato, tipizzazione_forte, web_oriented) VALUES
('Python', 0, 1, 1),
('C++', 1, 1, 0),
('JavaScript', 0, 0, 1),
('Java', 1, 1, 1),
('PHP', 0, 0, 1);
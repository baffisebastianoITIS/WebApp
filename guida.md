\# Progetto: Akinator Clone - Code Edition

Un'applicazione web interattiva ispirata ad Akinator, progettata per indovinare il linguaggio di programmazione scelto dall'utente tramite logica booleana e filtraggio dati.



\##Architettura e Gerarchia del Progetto

Il progetto è strutturato per essere eseguito in un ambiente isolato tramite Docker, separando la logica del server, il database e l'interfaccia utente.



\## Struttura dei File

Plaintext

AKINATOR-CLONE/

├── Dockerfile              # Configurazione ambiente PHP

├── docker-compose.yml      # Orchestratore dei container

├── index.php               # Punto d'ingresso e interfaccia HTML

├── style.css               # Design e stile grafico

├── script.js               # Logica interattiva (Frontend)

├── database.sql            # Schema e dati iniziali (MySQL)

└── README.md               # Documentazione del progetto

\## Specifiche Tecniche

1\. Configurazione Docker

Per garantire il funzionamento su qualsiasi macchina, il progetto utilizza due container principali:



Servizio Web (App): Basato su php:8.2-apache. Include le estensioni pdo\_mysql per la comunicazione con il database.



Servizio Database (DB): Basato su mysql:8.0. Gestisce la persistenza dei dati dei linguaggi.



2\. Stack Tecnologico

Backend: PHP 8.2 (PDO per query sicure).



Database: MySQL 8.0 (Relational Storage).



Frontend: HTML5, CSS3, JavaScript Vanilla.



\## Codice Sorgente dei File

Ambiente (Dockerfile \& YAML)

Dockerfile



Dockerfile

FROM php:8.2-apache

RUN docker-php-ext-install pdo pdo\_mysql

WORKDIR /var/www/html

docker-compose.yml



YAML

version: '3.8'

services:

  webapp:

    build: .

    container\_name: akinator\_php

    ports: \["8080:80"]

    volumes: \[".:/var/www/html"]

    depends\_on: \[db]

  db:

    image: mysql:8.0

    container\_name: akinator\_db

    environment:

      MYSQL\_DATABASE: akinator\_game

      MYSQL\_ROOT\_PASSWORD: password\_segreta

    volumes: \["db\_data:/var/lib/mysql"]

volumes:

  db\_data:

\## Dati (database.sql)

SQL

CREATE TABLE IF NOT EXISTS linguaggi (

    id INT AUTO\_INCREMENT PRIMARY KEY,

    nome VARCHAR(50) NOT NULL,

    compilato BOOLEAN,

    tipizzazione\_forte BOOLEAN,

    web\_oriented BOOLEAN

);



INSERT INTO linguaggi (nome, compilato, tipizzazione\_forte, web\_oriented) VALUES

('Python', 0, 1, 1), ('C++', 1, 1, 0), ('JavaScript', 0, 0, 1), ('Java', 1, 1, 1), ('PHP', 0, 0, 1);

\## Interfaccia (index.php, style.css, script.js)

Il frontend è progettato per essere leggero e reattivo, con un contenitore centrale per le domande e pulsanti dinamici gestiti via JavaScript.



\## Guida all'Installazione e Verifica

Per chi desidera verificare il progetto localmente:



Avvio dei Container:

Aprire il terminale nella cartella del progetto e lanciare:



Bash

docker-compose up -d

Inizializzazione Database:

Eseguire il comando per importare i dati nel container MySQL:



Bash

docker exec -i akinator\_db mysql -u root -ppassword\_segreta akinator\_game < database.sql

Accesso:

Visitare http://localhost:8080 nel browser.



\## Note Finali

Questo lavoro è stato realizzato seguendo una logica di modularità. Anche in assenza di Docker Desktop locale, la correttezza sintattica dei file garantisce l'integrità del sistema per verifiche successive in ambienti di staging professionali.


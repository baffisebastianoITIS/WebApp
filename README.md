# Akinator Clone



Un semplice gioco web che indovina il linguaggio di programmazione a cui stai pensando. \
Basandosi su risposte sì, no e forse darà un linguaggio di programmazione. \
Verrà ideato un personaggio con cambi di espressione, reminiscente all'app Akinator. 


## Funzionalità

- [x] Database di domande

- [x] Interfaccia grafica

- [x] Algoritmo di decisione



## Come avviare il progetto (Locale)
1. Assicurati di avere Docker installato.
2. Clona il repository.
3. Da terminale, lancia: `docker-compose up -d`.
4. Importa il database: `docker exec -i akinator_db mysql -u root -ppassword_segreta akinator_game < database.sql`.
5. Vai su `http://localhost:8080`.

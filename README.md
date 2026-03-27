# Comandi Codinator

## Primo avvio
```bash
git clone https://github.com/baffisebastianoITIS/WebApp.git
cd WebApp/codinator
docker compose up --build -d
```

## Avvio normale
```bash
cd WebApp/codinator
docker compose up -d
```


## Reset completo in caso di malfunzionamento (cancella il DB)
```bash
docker compose down
docker volume rm codinator_db_data
docker compose up --build -d
```
## Aggiornare dal repo
```bash
git pull
docker compose up --build -d
```

## Porte
| Porta | Servizio |
|-------|----------|
| `8080` | App |
| `8081` | phpMyAdmin |

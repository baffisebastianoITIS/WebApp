# Comandi Codinator

## Primo avvio
```bash
cd /workspaces/WebAppClaude/codinator
docker compose up --build -d
```

## Avvio normale
```bash
docker compose up -d
```

## Fermare
```bash
docker compose down
```

## Reset completo (cancella il DB)
```bash
docker compose down
docker volume rm codinator_db_data
docker compose up --build -d
```

## Vedere i log
```bash
docker compose logs web
```

## Salvare le modifiche su GitHub
```bash
cd /workspaces/WebAppClaude
git add -A
git commit -m "messaggio"
git pull --rebase
git push
```

## Porte
| Porta | Servizio |
|-------|----------|
| `8080` | App |
| `8081` | phpMyAdmin |

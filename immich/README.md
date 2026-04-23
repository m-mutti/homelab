# Immich

Self-hosted photo and video management solution — a Google Photos alternative.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp .env .env.local
   ```

2. Update `.env` values:
   - `UPLOAD_LOCATION` — path where photos/videos will be stored
   - `DB_PASSWORD` — change from the default
   - `IMMICH_PORT` — defaults to `2283`

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Access Immich at `http://<server-ip>:2283` and create your admin account.

## Services

| Service               | Description                          |
| --------------------- | ------------------------------------ |
| immich-server         | Main API and web interface           |
| immich-machine-learning | ML model for smart search & faces  |
| redis                 | Cache layer                          |
| database              | PostgreSQL with pgvecto-rs extension |

## Backup

Back up these locations regularly:
- `UPLOAD_LOCATION` — all uploaded media
- `DB_DATA_LOCATION` — database files (or use `pg_dump`)

## Updating

```bash
docker compose pull
docker compose up -d
```

# Dawarich

Self-hosted location history tracker — an open-source alternative to Google Maps
Timeline. Runs four containers: the Rails app, a Sidekiq background worker, a
PostGIS database, and Redis.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

   - Set a strong `POSTGRES_PASSWORD`.
   - Generate `SECRET_KEY_BASE` with `openssl rand -hex 64` and paste it in.
   - Avoid `$`, `!`, `^` in secrets — Docker Compose interprets them as variables.

2. Start the services:

   ```bash
   docker compose up -d
   ```

   First boot runs database migrations and seeds, so the app may take a minute
   to become healthy. Check progress with `docker compose logs -f dawarich_app`.

3. Access Dawarich at `http://<server-ip>:3000`.

   Default login: `demo@dawarich.app` / `password`. Change the password (and the
   email) immediately after first login.

## Nginx + SSL (optional)

To expose Dawarich at `https://${DOMAIN}`:

1. In `.env`, set `DOMAIN`, `CERTBOT_EMAIL`, then:
   - add your domain to `APPLICATION_HOSTS` (e.g. `dawarich.example.com,localhost,::1,127.0.0.1`)
   - set `APPLICATION_PROTOCOL=https`
2. Recreate the app so the new env takes effect:

   ```bash
   docker compose up -d
   ```

3. Deploy the reverse proxy:

   ```bash
   ./setup-nginx.sh
   ```

This deploys an HTTP-only config, obtains a Let's Encrypt cert via certbot, then
swaps in the full SSL config (with WebSocket support and a 2G upload limit for
Google Takeout / GPX imports).

## Mobile tracking

Point a tracking app (Overland, OwnTracks, or the Dawarich app) at your server's
URL using the API key found under **Account → your profile** in the web UI.

## Updating

```bash
docker compose pull
docker compose up -d
```

> Pin `freikin/dawarich:latest` to a specific version tag in `docker-compose.yml`
> before a major upgrade if you want to control when migrations run.

## Data

All state lives in named Docker volumes (`dawarich_db_data`, `dawarich_storage`,
`dawarich_public`, `dawarich_watched`, `dawarich_shared`). PostGIS needs real
Linux file permissions, so these stay on the local disk rather than the NTFS
external drive.

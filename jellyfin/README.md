# Jellyfin

Free, self-hosted media server for movies, TV shows, music, and more.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

   For a large library, point `JELLYFIN_MEDIA` at the external drive (e.g. `/mnt/external/media`).

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Access Jellyfin at `http://<server-ip>:8096` and complete the first-run wizard (admin account, libraries, etc.).

## Nginx + SSL (optional)

To expose Jellyfin at `https://${DOMAIN}`:

```bash
./setup-nginx.sh
```

This deploys an HTTP-only config, obtains a Let's Encrypt cert via certbot, then swaps in the full SSL config (with streaming-friendly timeouts and a 20G upload limit).

## Updating

```bash
docker compose pull
docker compose up -d
```

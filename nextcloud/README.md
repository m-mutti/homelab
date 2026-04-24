# Nextcloud

Self-hosted cloud storage and collaboration platform — a Google Drive/Dropbox alternative.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

2. Update `.env` values:
   - `ADMIN_USER` / `ADMIN_PASSWORD` — admin credentials
   - `DB_PASSWORD` / `DB_ROOT_PASSWORD` — change from defaults
   - `DOMAIN` — your domain for Nextcloud
   - `CERTBOT_EMAIL` — email for Let's Encrypt

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Set up nginx and SSL:

   ```bash
   ./setup-nginx.sh
   ```

5. Access Nextcloud at `https://<your-domain>`.

## Services

| Service   | Description                  |
| --------- | ---------------------------- |
| nextcloud | Main Nextcloud application   |
| db        | MariaDB for data storage     |
| redis     | Cache for improved performance |

## Backup

Back up these locations regularly:
- `NEXTCLOUD_DATA_LOCATION` — all user files and app data
- `DB_DATA_LOCATION` — database files (or use `mariadb-dump`)

## Updating

```bash
docker compose pull
docker compose up -d
```

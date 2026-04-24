# Overleaf

Self-hosted LaTeX editor — a collaborative online LaTeX platform.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

2. Update `.env` values:
   - `ADMIN_EMAIL` — admin account email
   - `DOMAIN` — your domain for Overleaf
   - `CERTBOT_EMAIL` — email for Let's Encrypt

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Set up nginx and SSL:

   ```bash
   ./setup-nginx.sh
   ```

5. Create the admin account by visiting `https://<your-domain>/launchpad`.

## Services

| Service   | Description                     |
| --------- | ------------------------------- |
| overleaf  | Main Overleaf application       |
| mongo     | MongoDB for document storage    |
| redis     | Cache and session storage       |

## Backup

Back up these locations regularly:
- `OVERLEAF_DATA_LOCATION` — project files and compiled PDFs
- `MONGO_DATA_LOCATION` — database files (or use `mongodump`)

## Updating

```bash
docker compose pull
docker compose up -d
```

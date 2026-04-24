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

4. Initialize the MongoDB replica set (required for transactions):

   ```bash
   docker exec overleaf_mongo mongosh --eval "rs.initiate({ _id: 'rs0', members: [{ _id: 0, host: 'mongo:27017' }] })"
   ```

   Then restart Overleaf to pick it up:

   ```bash
   docker compose restart overleaf
   ```

5. Set up nginx and SSL:

   ```bash
   ./setup-nginx.sh
   ```

6. Create the admin account by visiting `https://<your-domain>/launchpad`.

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

# n8n

Workflow automation platform for connecting APIs, scheduled jobs, webhooks, and internal tools.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

2. Update `.env` values:
   - `DOMAIN` - public domain, for example `n8n.mutti.cloud`.
   - `CERTBOT_EMAIL` - email for Let's Encrypt.
   - `N8N_ENCRYPTION_KEY` - generate once with `openssl rand -hex 32` and never rotate casually.
   - `POSTGRES_PASSWORD` - generate a strong database password.

3. Start the service:

   ```bash
   docker compose up -d
   ```

4. Set up nginx and SSL:

   ```bash
   ./setup-nginx.sh
   ```

5. Open `https://<your-domain>` and create the owner account.

## Mailcow SMTP

If you want n8n to send user-management email, invite email, or workflow email through mailcow, configure SMTP inside n8n credentials or set SMTP env vars later. Use:

```text
Host: mail.mutti.cloud
Port: 587
Security: STARTTLS
Username: full mailbox address, for example noreply@mutti.cloud
Password: mailbox password
From: noreply@mutti.cloud
```

## Webhooks

The compose file sets:

```bash
N8N_EDITOR_BASE_URL=https://${DOMAIN}
WEBHOOK_URL=https://${DOMAIN}/
```

This makes production webhook URLs use your public HTTPS domain.

## Updating

```bash
docker compose pull
docker compose up -d
```

## Backup

Back up both Docker volumes:

- `n8n-data` - workflows, credentials metadata, and config.
- `n8n-db-data` - Postgres database.

Keep `N8N_ENCRYPTION_KEY` backed up separately. Without it, existing credentials cannot be decrypted.

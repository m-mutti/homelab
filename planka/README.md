# Planka

Self-hosted Kanban boards for projects, lists, cards, attachments, and real-time collaboration.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

2. Update `.env` values:
   - `BASE_URL` - public URL for Planka. Use `http://<server-ip>:3000` for local-only access or `https://<domain>` behind nginx.
   - `SECRET_KEY` - generate with `openssl rand -hex 64`.
   - `DOMAIN` and `CERTBOT_EMAIL` - required only when using `setup-nginx.sh`.

3. Start the service:

   ```bash
   docker compose up -d
   ```

4. Create the first admin user:

   ```bash
   docker compose run --rm planka npm run db:create-admin-user
   ```

5. Access Planka at `http://<server-ip>:3000` or your configured `BASE_URL`.

## Nginx

After setting `BASE_URL=https://<domain>`, `DOMAIN`, and `CERTBOT_EMAIL` in `.env`, run:

```bash
./setup-nginx.sh
```

## Updating

```bash
docker compose pull
docker compose up -d
```

## Troubleshooting

If the browser logs repeated WebSocket failures for `/socket.io/`, redeploy the nginx config after confirming `.env` has `BASE_URL=https://<domain>`:

```bash
./setup-nginx.sh
```

Then verify nginx is serving the generated Planka config:

```bash
sudo nginx -T | grep -A 30 -B 5 'server_name planka.mutti.cloud'
sudo journalctl -u nginx -n 100 --no-pager
docker compose logs --tail=100 planka
```

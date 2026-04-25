# Homarr

A modern, self-hosted dashboard for all your services. Drag-and-drop UI with 40+ integrations and 10K+ built-in icons.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Access Homarr at `http://<server-ip>:7575` and create your admin account.

4. Add your services (Immich, Overleaf, Nextcloud, etc.) via the dashboard UI.

## Updating

```bash
docker compose pull
docker compose up -d
```

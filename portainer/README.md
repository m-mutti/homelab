# Portainer

A lightweight web UI for managing Docker containers, images, volumes, networks, and stacks.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Access Portainer at `http://<server-ip>:9000` and create the admin account within a few minutes of first start (Portainer locks initial setup after a short timeout — restart the container if it expires).

4. Choose the local Docker environment when prompted; it will use the mounted `/var/run/docker.sock`.

## Nginx + SSL (optional)

To expose Portainer at `https://${DOMAIN}`:

```bash
./setup-nginx.sh
```

This deploys an HTTP-only config, obtains a Let's Encrypt cert via certbot, then swaps in the full SSL config.

## Updating

```bash
docker compose pull
docker compose up -d
```

# Download Manager

Aria2 Pro plus AriaNg for managing HTTP, FTP, SFTP, BitTorrent, and Metalink downloads from a browser.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

2. Update `.env` values:
   - `RPC_SECRET` - generate with `openssl rand -hex 32`.
   - `DOWNLOADS_LOCATION` - where downloaded files should be written, for example `/mnt/external/downloads`.
   - `DOMAIN` and `CERTBOT_EMAIL` - required only when using `setup-nginx.sh`.
   - `PUID` and `PGID` - set to your server user IDs, usually `1000`.

3. Create the download directory if needed:

   ```bash
   mkdir -p /mnt/external/downloads
   ```

4. Start the service:

   ```bash
   docker compose up -d
   ```

5. Access AriaNg from your network at `http://<server-lan-ip>:6880`.

## AriaNg Connection

In AriaNg, open `AriaNg Settings` > `RPC` and set:

- Protocol: `http`
- Host: your server's LAN IP
- Port: `6800`
- Interface: `/jsonrpc`
- Secret token: your `RPC_SECRET`

Set `LAN_BIND_IP` in `.env` to your server's LAN IP for LAN-only access. Do not port-forward `ARIANG_PORT` or `ARIA2_RPC_PORT` from your router to the internet.

## Updating

```bash
docker compose pull
docker compose up -d
```

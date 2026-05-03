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

5. Access AriaNg from the server at `http://127.0.0.1:6880`.

## AriaNg Connection

In AriaNg, open `AriaNg Settings` > `RPC` and set:

- Protocol: `http`
- Host: `127.0.0.1`
- Port: `6800`
- Interface: `/jsonrpc`
- Secret token: your `RPC_SECRET`

The web UI and Aria2 RPC endpoint are both bound to `127.0.0.1`, so they are not reachable from other machines unless you use SSH tunneling or a VPN.

## Updating

```bash
docker compose pull
docker compose up -d
```

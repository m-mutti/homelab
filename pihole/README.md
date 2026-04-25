# Pi-hole

Network-wide DNS-level ad and tracker blocker.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

2. Update `.env` values:
   - `PIHOLE_PASSWORD` — admin dashboard password
   - `TZ` — your timezone
   - `UPSTREAM_DNS` — DNS servers Pi-hole forwards to (default: Cloudflare + Google)

3. Start the service:

   ```bash
   docker compose up -d
   ```

4. Access the admin dashboard at `http://<server-ip>:8082/admin`.

5. Set your router's DNS to your server's IP address so all devices on the network use Pi-hole.

## Router Configuration

1. Log into your router admin panel
2. Find DHCP / DNS settings
3. Set the primary DNS server to your server's IP
4. Optionally set secondary DNS to the same IP (or leave blank to force all traffic through Pi-hole)
5. Reboot the router or renew DHCP leases on devices

## Updating

```bash
docker compose pull
docker compose up -d
```

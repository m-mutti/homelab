# mailcow

Self-hosted mail server suite using the official `mailcow-dockerized` project.

This folder is a wrapper around the upstream mailcow checkout. The generated `mailcow-dockerized/` directory is ignored by git so the service can be updated directly from upstream.

## Before You Start

Mail hosting is different from the other services in this repo:

- Do not use Cloudflare proxy or Cloudflare Tunnel for SMTP/IMAP/POP3.
- Your server needs a public IP with inbound and outbound port `25` available.
- Reverse DNS/PTR for the public IP must point to `MAILCOW_HOSTNAME`.
- Use a Linux filesystem for mailcow data. Do not put mailcow data on the NTFS external drive.
- Avoid installing another local MTA on the host, such as Postfix or Exim, because it will conflict with mailcow's ports.

## Setup

1. Copy and edit the environment file:

   ```bash
   cp sample.env .env
   ```

2. Set at least:

   ```bash
   MAILCOW_HOSTNAME=mail.example.com
   MAIL_DOMAIN=example.com
   CERTBOT_EMAIL=you@example.com
   ```

3. Bootstrap the official mailcow checkout:

   ```bash
   ./bootstrap-mailcow.sh
   ```

4. Start mailcow:

   ```bash
   cd mailcow-dockerized
   docker compose pull
   docker compose up -d
   ```

5. From the `mailcow/` folder, configure host nginx and copy the HTTPS certificate into mailcow:

   ```bash
   ./setup-nginx.sh
   ```

6. Open `https://mail.example.com` and log in with the initial mailcow admin credentials from the official setup output. Change the password immediately.

## DNS

For `MAIL_DOMAIN=example.com` and `MAILCOW_HOSTNAME=mail.example.com`, create these DNS records. In Cloudflare, keep them **DNS only** / gray-clouded.

| Type | Name | Value | Notes |
| ---- | ---- | ----- | ----- |
| A | `mail` | `<server-public-ipv4>` | Required |
| AAAA | `mail` | `<server-public-ipv6>` | Only if IPv6 is fully working |
| MX | `@` | `10 mail.example.com` | Required for receiving mail |
| TXT | `@` | `v=spf1 mx -all` | Start here if only mailcow sends mail for the domain |
| CNAME | `autoconfig` | `mail.example.com` | Mail client setup |
| CNAME | `autodiscover` | `mail.example.com` | Outlook/Exchange-style discovery |
| TXT | `_dmarc` | `v=DMARC1; p=none; rua=mailto:postmaster@example.com` | Start with `p=none`, tighten later |
| TXT | `<selector>._domainkey` | value from mailcow UI | Generate this after adding the domain in mailcow |

Also set reverse DNS/PTR at your ISP/VPS provider:

```text
<server-public-ip> -> mail.example.com
```

PTR is not configured in Cloudflare.

## Ports

Open these ports on the server firewall and router:

| Port | Protocol | Purpose |
| ---- | -------- | ------- |
| 25 | TCP | SMTP server-to-server mail |
| 465 | TCP | SMTPS submission |
| 587 | TCP | SMTP submission |
| 993 | TCP | IMAPS |
| 995 | TCP | POP3S, optional |
| 4190 | TCP | ManageSieve, optional |
| 80 | TCP | nginx ACME challenge and HTTP redirect |
| 443 | TCP | mailcow web UI, autodiscover, autoconfig |

## Certificates

This repo keeps host nginx in charge of public HTTPS. `setup-nginx.sh` obtains a Let's Encrypt certificate for:

- `MAILCOW_HOSTNAME`
- `autoconfig.MAIL_DOMAIN`
- `autodiscover.MAIL_DOMAIN`

Then it runs `sync-certs.sh`, which copies the certificate into:

```text
mailcow-dockerized/data/assets/ssl/cert.pem
mailcow-dockerized/data/assets/ssl/key.pem
```

Run this after certificate renewals:

```bash
./sync-certs.sh
```

You can add it as a certbot deploy hook later.

## Updating

```bash
cd mailcow-dockerized
./update.sh
```

## References

- Official install docs: https://docs.mailcow.email/getstarted/install/
- DNS prerequisites: https://docs.mailcow.email/getstarted/prerequisite-dns/
- Reverse proxy docs: https://docs.mailcow.email/post_installation/reverse-proxy/r_p/

# Project Information

This project will be used to deploy services on my personal server. I will make everything here and run it on my server. Create each service in a new folder. Try to use docker as much as possible because I dont want to make my server dirty. Make sure to create `README.md` file with each folder.

## Services

| Service    | Folder       | Port  |
| ---------- | ------------ | ----- |
| Immich     | `immich/`    | 2283  |
| Overleaf   | `overleaf/`  | 18080 |
| Nextcloud  | `nextcloud/` | 8081  |
| Homarr     | `homarr/`    | 7575  |
| Pi-hole    | `pihole/`    | 8082  |

## Server Details

- OS: Ubuntu Linux
- External drive: NTFS (`fuseblk`) mounted at `/mnt/external` — does NOT support Linux file permissions (`chmod`/`chown` won't work)

## Structure Per Service

Each service folder contains:
- `docker-compose.yml` — service definition
- `sample.env` — template environment file (committed to git)
- `.env` — actual config with secrets (gitignored)
- `*.nginx.conf` — nginx template with `${DOMAIN}` and port variables
- `setup-nginx.sh` — script to deploy nginx config, obtain SSL cert via certbot, and create symlinks to `sites-available`/`sites-enabled`
- `.gitignore` — ignores `.env`, `data/`, `*.generated.conf`
- `README.md` — setup and usage docs

## Important Notes

- Nginx setup uses a 3-step process: deploy HTTP-only config → run certbot → deploy full SSL config
- Overleaf requires MongoDB replica set initialization after first deploy: `docker exec overleaf_mongo mongosh --eval "rs.initiate(...)"`
- Overleaf TeX Live packages need a volume (`texlive`) to persist across container recreations
- NTFS drive limitations affect Nextcloud and any service needing Linux file permissions
- Passwords in `.env` files should avoid `$`, `!`, `^` characters as Docker Compose interprets them as variables

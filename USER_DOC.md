# User Documentation — Inception

## Overview

This project provides a WordPress website running behind an NGINX reverse proxy with TLS encryption, backed by a MariaDB database. All services run in Docker containers.

## Services

| Service | Description | Container |
|---------|-------------|-----------|
| NGINX | Reverse proxy with HTTPS (TLSv1.2/1.3) | `nginx` |
| WordPress | CMS with PHP-FPM | `wordpress` |
| MariaDB | Database server | `mariadb` |

## Starting and Stopping

```bash
# Start the project (builds if needed)
make

# Stop the project
make down

# Restart with a fresh build
make re

# Full cleanup (removes all data)
make fclean
```

## Accessing the Website

1. Ensure your `/etc/hosts` file contains:
   ```
   127.0.0.1 tishihar.42.fr
   ```
2. Open your browser and navigate to: **https://tishihar.42.fr**
3. Accept the self-signed certificate warning (expected behavior).

## WordPress Administration

- **Admin Panel**: https://tishihar.42.fr/wp-admin
- **Admin Username**: Defined in `srcs/.env` as `WP_ADMIN_USER`
- **Admin Password**: Stored in `secrets/wp_admin_password.txt`

## Credentials

Credentials are stored in two locations:
- **`srcs/.env`** — Contains non-sensitive config (usernames, domain, email addresses)
- **`secrets/`** — Contains password files (not committed to Git):
  - `db_root_password.txt` — MariaDB root password
  - `db_password.txt` — MariaDB WordPress user password
  - `wp_admin_password.txt` — WordPress admin password
  - `wp_user_password.txt` — WordPress regular user password

> ⚠️ Never commit the `secrets/` directory or `.env` file to a public repository.

## Checking Service Status

```bash
# View container status
make ps

# View container logs
make logs

# Check individual container
docker exec -it nginx nginx -t
docker exec -it mariadb mysqladmin ping -u root -p
docker exec -it wordpress wp --allow-root core version
```
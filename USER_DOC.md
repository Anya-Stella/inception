# User Documentation — Inception

This guide is for end users of the Inception WordPress site.
For developer documentation, see [DEV_DOC.md](DEV_DOC.md).

## Overview

Inception is a Docker-based WordPress hosting environment consisting of three services:

| Service | Role | Technology |
|---------|------|------------|
| **NGINX** | Web server (HTTPS) | TLSv1.2/1.3 |
| **WordPress** | Content Management System | PHP-FPM |
| **MariaDB** | Database server | Relational DB |

## Starting and Stopping

### Start the Site

```bash
make
```

On first run, images will be built (may take a few minutes).

### Stop the Site

```bash
make down
```

### Full Reset (Delete All Data)

```bash
make fclean
```

Then restart with `make`.

## Accessing the Website

### Prerequisites

Ensure `/etc/hosts` on your host machine contains:

```
127.0.0.1 tishihar.42.fr
```

### Access the Website

Open your browser and navigate to:

```
https://tishihar.42.fr
```

**Note:** A self-signed certificate is used. Accept the security warning to proceed.

### Access WordPress Admin Panel

1. Navigate to https://tishihar.42.fr/wp-admin
2. Log in with:
   - **Username:** Value of `WP_ADMIN_USER` in `srcs/.env`
   - **Password:** Contents of `secrets/wp_admin_password.txt`

## Credential Management

### File Structure

```
secrets/
├── db_root_password.txt          # MariaDB root password
├── db_password.txt               # MariaDB WordPress user password
├── wp_admin_password.txt         # WordPress admin password
└── wp_user_password.txt          # WordPress regular user password

srcs/.env                          # Environment variables (usernames, etc.)
```

### Login Reference

| Use Case | Username | Password | Location |
|----------|----------|----------|----------|
| **WordPress Admin** | `WP_ADMIN_USER` | `secrets/wp_admin_password.txt` | wp-admin |
| **Regular User** | `wp_user` | `secrets/wp_user_password.txt` | WordPress |
| **DB Access (Dev)** | `wp_user` | `secrets/db_password.txt` | - |

## Status Check

### Container Status

```bash
make ps
```

If all services show "Up", the infrastructure is running:

```
NAME          STATUS      PORTS
nginx         Up 2 days   0.0.0.0:443->443/tcp
wordpress     Up 2 days
mariadb       Up 2 days
```

### View Logs

```bash
# Show all service logs
make logs

# Real-time logs (Ctrl+C to exit)
make logs -f
```

## Frequently Asked Questions

### Q: I see "Connection Reset"

A: Check the following:
- Is `/etc/hosts` configured with `127.0.0.1 tishihar.42.fr`?
- Are you using HTTPS (not HTTP)?
- Is `make ps` showing all containers as "Up"?

### Q: Can't Log Into WordPress

A: Verify:
- Username and password match the configured values
- Caps Lock is not active
- No extra newlines in `secrets/wp_admin_password.txt`

### Q: Site Won't Start

```bash
# Check logs
make logs

# Full reset and restart
make fclean
make
```

### Q: SSL Certificate Warning

A: This project uses a self-signed certificate. Warnings are normal. For production, use a certificate from a trusted Certificate Authority (CA).

## Support

For issues or questions, contact your administrator.
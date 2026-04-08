*This project has been created as part of the 42 curriculum by tishihar.*

# Inception — Docker Infrastructure Project

## Overview

Inception is a system administration project using Docker and Docker Compose to containerize multiple web services and manage them on a virtual machine.

**Project Services:**
- **NGINX** — HTTPS-enabled reverse proxy (TLSv1.2/1.3) on port 443
- **WordPress** — CMS running with PHP-FPM
- **MariaDB** — Relational database for WordPress

## Quick Start

### Prerequisites
- Docker and Docker Compose V2 installed
- Running on a virtual machine
- `/etc/hosts` configured: `127.0.0.1 tishihar.42.fr`

### Basic Commands
```bash
make        # Build images and start containers
make down   # Stop and remove containers
make re     # Clean rebuild and restart
make fclean # Full cleanup (images, volumes, data)
```

### Access
- **Website:** https://tishihar.42.fr
- **WordPress Admin:** https://tishihar.42.fr/wp-admin

## Project Structure

```
.
├── Makefile                          # Build and task definitions
├── secrets/                          # Passwords and secrets (Git-excluded)
│   ├── db_root_password.txt
│   ├── db_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── docker-compose.yml            # Docker Compose configuration
    ├── .env                          # Environment variables (Git-excluded)
    └── requirements/
        ├── nginx/                    # NGINX container
        │   ├── Dockerfile
        │   ├── conf/default.conf
        │   └── tools/setup_nginx.sh
        ├── wordpress/                # WordPress container
        │   ├── Dockerfile
        │   ├── conf/www.conf
        │   └── tools/setup_wordpress.sh
        └── mariadb/                  # MariaDB container
            ├── Dockerfile
            ├── conf/50-server.cnf
            └── tools/setup_mariadb.sh
```

## Key Concepts

### Docker Containers vs Virtual Machines
- **Docker Containers** — Share host OS kernel, process-level isolation, fast and lightweight
- **Virtual Machines** — Full OS emulation, stronger isolation, higher resource overhead

### Environment Variables vs Secrets
- **Environment Variables (`.env`)** — Non-sensitive config (domain, usernames)
- **Secrets Files** — Sensitive data (passwords, keys) mounted at `/run/secrets/`

### Docker Networking
- **Bridge Network** — Isolated container communication with DNS resolution
- **Host Network** — No isolation; not used in this project for security reasons

### Volume Persistence
- WordPress and MariaDB data persisted at `/home/tishihar/data/`
- Managed by Docker named volumes

## Documentation

- [**User Documentation**](USER_DOC.md) — For site users (startup, access)
- [**Developer Documentation**](DEV_DOC.md) — For developers (setup, customization, troubleshooting)

## References

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress CLI Handbook](https://make.wordpress.org/cli/handbook/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
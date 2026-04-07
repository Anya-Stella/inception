*This project has been created as part of the 42 curriculum by tishihar.*

# Inception

## Description

Inception is a system administration project that introduces Docker containerization. The goal is to set up a small infrastructure composed of different services running in dedicated Docker containers, orchestrated by Docker Compose inside a virtual machine.

The infrastructure includes:
- **NGINX** — Web server with TLSv1.2/TLSv1.3, the sole entry point via port 443
- **WordPress** — CMS running with PHP-FPM (without NGINX)
- **MariaDB** — Relational database for WordPress

### Docker vs Virtual Machines
Docker containers share the host OS kernel and provide process-level isolation, making them lightweight and fast to start. Virtual Machines emulate full hardware and run a complete guest OS, offering stronger isolation but with greater resource overhead.

### Secrets vs Environment Variables
Environment variables (`.env`) store non-sensitive configuration (domain name, usernames). Docker Secrets store sensitive data (passwords, keys) in files mounted at `/run/secrets/` inside containers, never exposed as environment variables or in image layers.

### Docker Network vs Host Network
Docker bridge networks provide isolated communication between containers with DNS resolution by container name. Host networking removes network isolation and binds containers directly to the host's network stack, which is less secure and not used in this project.

### Docker Volumes vs Bind Mounts
Named Docker volumes are managed by Docker and provide portability and lifecycle management. Bind mounts map a specific host directory to a container path. This project uses named volumes with local driver options to persist data at `/home/tishihar/data/`.

## Instructions

### Prerequisites
- Docker and Docker Compose V2 installed
- Running inside a Virtual Machine (as per subject requirements)
- `/etc/hosts` configured: `127.0.0.1 tishihar.42.fr`

### Build and Run
```bash
make        # Build images and start all containers
make down   # Stop and remove containers
make re     # Rebuild and restart
make fclean # Full cleanup (images, volumes, data)
```

### Access
- Website: https://tishihar.42.fr
- WordPress Admin: https://tishihar.42.fr/wp-admin

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress CLI Handbook](https://make.wordpress.org/cli/handbook/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

### AI Usage
AI was used to assist with:
- Reviewing Dockerfile best practices and troubleshooting configuration issues
- Generating boilerplate for setup scripts
- All AI-generated content was reviewed, tested, and adapted manually
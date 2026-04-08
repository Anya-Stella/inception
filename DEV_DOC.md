# Developer Documentation — Inception

Setup, customization, and troubleshooting guide for the development environment.

## Initial Setup

### Prerequisites

- Virtual Machine with Docker and Docker Compose V2 installed
- `git` installed
- Repository access

### Step 1: Clone Repository

```bash
git clone <repository-url>
cd inception
```

### Step 2: Configure Secrets

Create the `secrets/` directory and set up password files:

```bash
mkdir -p secrets
echo "DbRootPassword123" > secrets/db_root_password.txt
echo "DbUserPassword456" > secrets/db_password.txt
echo "WpAdminPassword789" > secrets/wp_admin_password.txt
echo "WpUserPassword000" > secrets/wp_user_password.txt
```

**Note:** Each file should contain exactly one line with the password (no trailing newline).

### Step 3: Configure Environment Variables

Create/edit `srcs/.env`:

```env
LOGIN=tishihar
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wp_user
MYSQL_HOST=mariadb
DOMAIN_NAME=tishihar.42.fr
WP_TITLE=Inception WordPress
WP_ADMIN_USER=wpmaster         # Must NOT contain 'admin'
WP_ADMIN_EMAIL=admin@example.com
WP_USER=user42
WP_USER_EMAIL=user42@example.com
```

**Important:**
- WP_ADMIN_USER cannot contain the string 'admin'
- `.env` must NOT be committed to Git (add to `.gitignore`)

### Step 4: Configure DNS

Add to `/etc/hosts`:

```
127.0.0.1 tishihar.42.fr
```

## Build and Run

### Makefile Targets

| Command | Description |
|---------|-------------|
| `make` | Build images and start containers |
| `make start` | Start stopped containers |
| `make stop` | Stop containers (don't remove) |
| `make down` | Stop and remove containers |
| `make re` | Clean rebuild and restart |
| `make fclean` | Full cleanup (images, volumes, data) |
| `make logs` | View logs |
| `make ps` | Show container status |

### Usage Examples

```bash
# Initial startup
make

# Restart containers
make re

# Full reset
make fclean
make
```

## Container Management

### Shell Access

```bash
# Connect to NGINX container
docker exec -it inception-nginx-1 bash

# Connect to WordPress container
docker exec -it inception-wordpress-1 bash

# Connect to MariaDB container
docker exec -it inception-mariadb-1 bash
```

### View Logs

```bash
# Real-time logs for all services
docker compose -f srcs/docker-compose.yml logs -f

# Logs for specific service
docker compose -f srcs/docker-compose.yml logs wordpress

# Last 100 lines
docker compose -f srcs/docker-compose.yml logs --tail=100
```

### Service Operations

```bash
# Restart WordPress
docker compose -f srcs/docker-compose.yml restart wordpress

# Restart MariaDB
docker compose -f srcs/docker-compose.yml restart mariadb

# Test NGINX configuration
docker exec -it inception-nginx-1 nginx -t
```

## Data Persistence

### Volume Mappings

| Volume | Host Path | Container Path |
|--------|-----------|----------------|
| `wordpress_data` | `/home/tishihar/data/wordpress` | `/var/www/html` |
| `mariadb_data` | `/home/tishihar/data/mariadb` | `/var/lib/mysql` |

- Directories are auto-created by Makefile
- Data persists after container removal at `/home/tishihar/data/`
- Completely removed by `make fclean`

## Troubleshooting

### Port 443 Already in Use

```bash
# Check which process uses port 443
sudo lsof -i :443

# Kill conflicting process or modify docker-compose.yml
```

### Database Connection Errors

```bash
# Check MariaDB status
docker exec -it inception-mariadb-1 mysqladmin ping -u root -p

# Test WordPress DB access
docker exec -it inception-wordpress-1 wp db check --allow-root
```

### NGINX Configuration Errors

```bash
# Verify NGINX config
docker exec -it inception-nginx-1 nginx -t

# Check NGINX logs
docker compose -f srcs/docker-compose.yml logs nginx
```

### Volume Issues

```bash
# List all volumes
docker volume ls

# Inspect specific volume
docker volume inspect inception_wordpress_data

# Clean up unused volumes
docker volume prune
```

## Customization

### Modify NGINX Configuration

- Edit: `srcs/requirements/nginx/conf/default.conf`
- Rebuild with: `make re`

### Install WordPress Plugins/Themes

```bash
# Install plugin via WordPress CLI
docker exec -it inception-wordpress-1 wp plugin install <plugin-name> --allow-root

# Install theme
docker exec -it inception-wordpress-1 wp theme install <theme-name> --allow-root
```

### Modify MariaDB Configuration

- Edit: `srcs/requirements/mariadb/conf/50-server.cnf`
- Rebuild with: `make re`

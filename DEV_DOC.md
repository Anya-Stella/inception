# Developer Documentation — Inception

## Setting Up the Environment from Scratch

### Prerequisites

- A Virtual Machine with Docker and Docker Compose V2 installed
- `git` installed
- Access to the repository

### 1. Clone the Repository

```bash
git clone <repository-url>
cd inception
```

### 2. Configure Secrets

Create the `secrets/` directory and populate the password files:

```bash
mkdir -p secrets
echo "YourDbRootPassword" > secrets/db_root_password.txt
echo "YourDbUserPassword" > secrets/db_password.txt
echo "YourWpAdminPassword" > secrets/wp_admin_password.txt
echo "YourWpUserPassword" > secrets/wp_user_password.txt
```

> Each file should contain exactly one line with the password (no trailing newline).

### 3. Configure Environment Variables

Edit `srcs/.env` to match your setup:

```env
LOGIN=your42login
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wp_user
MYSQL_HOST=mariadb
DOMAIN_NAME=your42login.42.fr
WP_TITLE=Inception WordPress
WP_ADMIN_USER=your_wp_admin_name    # Must NOT contain 'admin'
WP_ADMIN_EMAIL=youremail@example.com
WP_USER=user42
WP_USER_EMAIL=user42@example.com
```

### 4. Configure DNS

Add to `/etc/hosts`:
```
127.0.0.1 your42login.42.fr
```

## Building and Launching

### Makefile Targets

| Target | Command | Description |
|--------|---------|-------------|
| `make` / `make up` | `docker compose up --build` | Build images and start containers |
| `make build` | Same as `up` | Alias for up |
| `make start` | `docker compose start` | Start stopped containers |
| `make stop` | `docker compose stop` | Stop running containers |
| `make down` | `docker compose down` | Stop and remove containers |
| `make re` | `down` + `up --build` | Full rebuild and restart |
| `make clean` | `docker compose down -v` | Remove containers and volumes |
| `make fclean` | Full cleanup | Remove everything + prune |
| `make logs` | `docker compose logs` | View logs |
| `make ps` | `docker compose ps` | View container status |

### Docker Compose Configuration

The `docker-compose.yml` is located at `srcs/docker-compose.yml`. The Makefile references it with `-f srcs/docker-compose.yml`.

## Container Management

```bash
# Enter a container shell
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash

# View real-time logs
docker compose -f srcs/docker-compose.yml logs -f

# Restart a specific service
docker compose -f srcs/docker-compose.yml restart wordpress
```

## Data Persistence

### Volume Locations on Host

| Volume | Host Path | Container Path |
|--------|-----------|----------------|
| `wordpress_data` | `/home/tishihar/data/wordpress` | `/var/www/html` |
| `mariadb_data` | `/home/tishihar/data/mariadb` | `/var/lib/mysql` |

These directories are created automatically by `make up`.

### How Data Persists

- Named Docker volumes with `driver: local` and `device` option bind to host paths
- Data survives `make down` and `make stop`
- Data is removed only by `make clean` (volumes) or `make fclean` (volumes + directories)

## Project Structure

```
inception/
├── Makefile                    # Build and management commands
├── README.md                   # Project overview
├── USER_DOC.md                 # User documentation
├── DEV_DOC.md                  # This file
├── secrets/                    # Password files (gitignored)
│   ├── db_root_password.txt
│   ├── db_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── .env                    # Environment variables (gitignored)
    ├── docker-compose.yml      # Service orchestration
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/50-server.conf
        │   └── tools/setup_mariadb.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/default.conf
        │   └── tools/setup_nginx.sh
        └── wordpress/
            ├── Dockerfile
            ├── conf/www.conf
            └── tools/setup_wordpress.sh
```
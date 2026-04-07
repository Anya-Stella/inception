NAME = inception

COMPOSE = docker-compose -f srcs/docker-compose.yml
WORDPRESS_DATA = $(HOME)/data/wordpress
MARIADB_DATA = $(HOME)/data/mariadb

all: up

up:
	mkdir -p $(WORDPRESS_DATA)
	mkdir -p $(MARIADB_DATA)
	$(COMPOSE) up --build

build:
	mkdir -p $(WORDPRESS_DATA)
	mkdir -p $(MARIADB_DATA)
	$(COMPOSE) up --build

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

down:
	$(COMPOSE) down

re:
	$(COMPOSE) down
	mkdir -p $(WORDPRESS_DATA)
	mkdir -p $(MARIADB_DATA)
	$(COMPOSE) up --build

clean:
	$(COMPOSE) down -v

fclean: clean
	$(COMPOSE) down --rmi all --volumes --remove-orphans
	rm -rf $(WORDPRESS_DATA)
	rm -rf $(MARIADB_DATA)
	docker system prune -f

logs:
	$(COMPOSE) logs

ps:
	$(COMPOSE) ps

.PHONY: all up down stop start re clean fclean logs ps build

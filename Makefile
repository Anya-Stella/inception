NAME = inception

LOGIN = tishihar
COMPOSE = docker-compose -f srcs/docker-compose.yml

WORDPRESS_DATA = /home/$(LOGIN)/data/wordpress
MARIADB_DATA = /home/$(LOGIN)/data/mariadb

all: up

up:
	mkdir -p $(WORDPRESS_DATA)
	mkdir -p $(MARIADB_DATA)
	$(COMPOSE) up --build

build:
	mkdir -p $(WORDPRESS_DATA)
	mkdir -p $(MARIADB_DATA)
	$(COMPOSE) build

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

down:
	$(COMPOSE) down

re:
	$(COMPOSE) down
	rm -rf $(WORDPRESS_DATA)
	rm -rf $(MARIADB_DATA)
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

.PHONY: all up build start stop down re clean fclean logs ps
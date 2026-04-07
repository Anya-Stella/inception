FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	php7.4-fpm \
	php7.4-mysql \
	php7.4-cli \
	php7.4-curl \
	php7.4-gd \
	php7.4-mbstring \
	php7.4-xml \
	php7.4-zip \
	mariadb-client \
	curl \
	ca-certificates \
	less \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh

RUN chmod +x /usr/local/bin/setup_wordpress.sh \
	&& mkdir -p /run/php

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]
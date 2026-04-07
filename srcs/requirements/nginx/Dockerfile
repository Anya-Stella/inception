FROM debian:bullseye

# install
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# mv host -> container
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf
COPY ./tools/setup_nginx.sh /usr/local/bin/setup_nginx.sh

RUN chmod +x /usr/local/bin/setup_nginx.sh

EXPOSE 443

# life of this container　begins here
ENTRYPOINT ["/usr/local/bin/setup_nginx.sh"]
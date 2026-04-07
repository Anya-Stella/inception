FROM debian:bullseye

# install mariadb_server
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# mv host -> container
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/setup_mariadb.sh /usr/local/bin/setup_mariadb.sh

RUN chmod +x /usr/local/bin/setup_mariadb.sh

EXPOSE 3306

# life of this container　begins here
ENTRYPOINT ["/usr/local/bin/setup_mariadb.sh"]
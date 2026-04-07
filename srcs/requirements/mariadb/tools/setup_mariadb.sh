#!/bin/bash
set -e

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -f /var/lib/mysql/.inception_initialized ]; then
    rm -rf /var/lib/mysql/*

    mysql_install_db \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --auth-root-authentication-method=normal

    mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    pid="$!"

    until mariadb-admin --protocol=SOCKET --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
        sleep 1
    done

    mariadb --protocol=SOCKET --socket=/run/mysqld/mysqld.sock -uroot << EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    touch /var/lib/mysql/.inception_initialized

    unset MYSQL_HOST
    mariadb-admin \
        --protocol=SOCKET \
        --socket=/run/mysqld/mysqld.sock \
        -uroot \
        -p"${DB_ROOT_PASSWORD}" \
        shutdown

    wait "$pid"
fi

exec mysqld --user=mysql --console
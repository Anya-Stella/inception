#!/bin/bash
set -e

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
	pid="$!"

	until mariadb-admin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
		sleep 1
	done

	mariadb --socket=/run/mysqld/mysqld.sock -uroot << EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

	mariadb-admin --socket=/run/mysqld/mysqld.sock -uroot shutdown
	wait "$pid"
fi

exec mysqld --user=mysql --console
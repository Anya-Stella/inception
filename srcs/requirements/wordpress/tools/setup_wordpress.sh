#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

WP_PATH="/var/www/html"

mkdir -p /run/php
mkdir -p "$WP_PATH"

cd "$WP_PATH"

echo "Waiting for MariaDB..."
until mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$DB_PASSWORD" --silent; do
    sleep 2
done

if [ ! -f wp-load.php ]; then
    wp core download --allow-root --path="$WP_PATH"
fi

if [ ! -f wp-config.php ]; then
    wp config create \
        --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --path="$WP_PATH" \
        --skip-check

    wp config set FS_METHOD direct --allow-root --path="$WP_PATH"
fi

if ! wp core is-installed --allow-root --path="$WP_PATH"; then
    wp core install \
        --allow-root \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --path="$WP_PATH"

    if ! wp user get "$WP_USER" --allow-root --path="$WP_PATH" >/dev/null 2>&1; then
        wp user create "$WP_USER" "$WP_USER_EMAIL" \
            --user_pass="$WP_USER_PASSWORD" \
            --role=author \
            --allow-root \
            --path="$WP_PATH"
    fi
fi

chown -R www-data:www-data "$WP_PATH"

exec /usr/sbin/php-fpm7.4 -F
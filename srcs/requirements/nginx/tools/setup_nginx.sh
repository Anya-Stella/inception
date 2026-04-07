#!/bin/bash
set -e

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=JP/ST=Tokyo/L=Tokyo/O=42/OU=student/CN=${DOMAIN_NAME}"

# replace localhost -> DOMAIN_NAME
sed -i "s/server_name localhost;/server_name ${DOMAIN_NAME};/" /etc/nginx/conf.d/default.conf

# execute at foreground
exec nginx -g "daemon off;"
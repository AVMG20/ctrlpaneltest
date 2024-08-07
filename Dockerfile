# Use the official PHP image as the base image
FROM serversideup/php:8.2-fpm-nginx-bookworm AS base

ENV SSL_MODE="off"

# Switch to root so we can do root things
USER root

RUN install-php-extensions intl pdo_mysql redis sodium zip opcache pcntl mysqli gd bcmath

# Use the build arguments to change the UID
# and GID of www-data while also changing
# the file permissions for NGINX
RUN docker-php-serversideup-set-id www-data 9999:9999 && \
    \
    # Update the file permissions for our NGINX service to match the new UID/GID
    docker-php-serversideup-set-file-permissions --owner 9999:9999 --service nginx

WORKDIR /var/www/html

# Copy existing application directory contents
COPY --chown=www-data:www-data . /var/www/html

# copy nginx configuration to nginx
COPY --chown=www-data:www-data ./nginx/default.conf /etc/nginx/conf.d/custom.conf

# Switch to the www-data user
USER www-data

# Install PHP dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

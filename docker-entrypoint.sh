#!/bin/sh
set -e

cd /var/www/html

# Install project dependencies
composer install --optimize-autoloader --no-dev

# Generate a key
php artisan key:generate

# Run Laravel commands
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run database migrations
php artisan migrate --force

# Start PHP-FPM
php-fpm
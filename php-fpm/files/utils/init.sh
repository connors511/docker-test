#!/usr/bin/env bash

# exit immediately if a command exits with a non-zero status.
set -eo pipefail

if [ ! -z "${WAIT_FOR_MYSQL}" ]; then
    # wait for mysql to start
    while ! echo exit | nc mysql 3306 >/dev/null; do sleep 2; done
fi

sed -i 's/?!#\(.*artisan schedule.*\)/# \1/' /etc/crontabs/www-data

if [ -z "${DEV}" ] || [ "${DEV}" != "1" ]
then
    echo "Caching configuration and routes..."
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    php artisan event:cache
else
    echo "Development mode.."
    php artisan cache:clear
    php artisan config:clear
    php artisan event:clear
    php artisan optimize:clear
    php artisan view:clear
    php artisan route:clear
    echo "Ensuring composer dependencies"
    composer install
fi

if [ -z "${SKIP_MIGRATIONS}" ]
then
    echo "Running migrations"
    php artisan migrate --force
else
    echo "Skipping migrations"
fi

echo "Publishing vendor assets"
php artisan horizon:assets

if [ -d "${WORK_DIR}/vendor/appstract/laravel-opcache" ]; then
    echo "Spawning child process to prime OPcache"
    # Hack to compile opcache after webserver has startet
    if [ "$OPCACHE_VERSION" = "2" ]; then
        sleep 20s && php artisan opcache:optimize &
    fi
    if [ "$OPCACHE_VERSION" = "3" ]; then
        sleep 20s && php artisan opcache:compile --force &
    fi
else
    echo "Skipping OPcache optimization"
fi
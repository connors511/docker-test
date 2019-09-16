#!/usr/bin/env bash

# exit immediately if a command exits with a non-zero status.
set -euo pipefail

# if [ -n "mysql" ]; then
#     # wait for mysql to start
#     while ! echo exit | nc mysql 3306 >/dev/null; do sleep 2; done
# fi

echo "export PS1='🐳  \[\033[1;36m\]\h \[\033[1;34m\]\W\[\033[0;35m\] \[\033[1;36m\]# \[\033[0m\]'" >> $HOME/.bashrc
echo "alias ll='ls -lh'" >> $HOME/.bashrc
echo "alias art='php artisan'" >> $HOME/.bashrc
echo "alias phpunit='vendor/bin/phpunit'" >> $HOME/.bashrc
echo "alias p='phpunit'" >> $HOME/.bashrc
echo "alias pf='phpunit --filter'" >> $HOME/.bashrc
echo "alias pst='phpunit --stop-on-failure'" >> $HOME/.bashrc
echo "alias paratest='vendor/bin/paratest --colors'" >> $HOME/.bashrc

echo "Caching configuration and routes..."
php artisan config:cache
php artisan route:cache

php artisan migrate --force
php artisan horizon:assets

# Hack to compile opcache after webserver has startet
if [ "$OPCACHE_VERSION" = "2" ]
then
    sleep 20s && php artisan opcache:optimize &
fi
if [ "$OPCACHE_VERSION" = "3" ]
then
    sleep 20s && php artisan opcache:compile --force &
fi

/sbin/runit-wrapper
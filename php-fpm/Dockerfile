FROM phpearth/php:7.3-nginx

# DEV=1 => turns off caching stuff
# SKIP_MIGRATIONS => doesnt call migrate on startup
# WAIT_FOR_MYSQL => waits for mysql to come up
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="32531" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="256" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10" \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER="16" \
    WORK_DIR="/var/www/html" \
    OPCACHE_VERSION="2" \
    COMPOSER_HOME="/.composer"

WORKDIR $WORK_DIR

RUN apk add --no-cache \
        bash bash-doc bash-completion openrc supervisor mysql-client composer \
        # PHP stuff
        php7.3-gd \
        php7.3-imagick \
        php7.3-imap \
        php7.3-intl \
        php7.3-memcached \
        php7.3-pcntl \
        php7.3-pdo_mysql \
        php7.3-redis \
        php7.3-soap \
        php7.3-sqlite3 \
        php7.3-tidy \
        # Horizon / Websocket
        php7.3-phar \
        php7.3-session \
        php7.3-sysvmsg \
        php7.3-sysvsem \
        php7.3-sysvshm \
        php7.3-tokenizer \
        php7.3-xml && \
    # Needed to allow OPcache config via ENV vars
    sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/7.3/php-fpm.d/www.conf && \
    # Prep crontab
    echo '# * * * * * php /var/www/html/artisan schedule:run' >> /etc/crontabs/www-data && \
    sed -i -e '$a\\' /etc/crontabs/www-data && \
    # Disable artisan scheduler
    sed -i 's/?!#\(.*artisan schedule.*\)/# \1/' /etc/crontabs/www-data && \
    chmod -R 755 /var/www && \
    chown -R www-data:www-data /var/www && \
    rm /etc/nginx/conf.d/default.conf && \
    composer global require hirak/prestissimo && \
    chmod -R 777 ${COMPOSER_HOME} && \
    chown -R www-data:www-data ${COMPOSER_HOME}

COPY files /

ENTRYPOINT ["/utils/entrypoint.sh"]
CMD ["api"]


# TODO:
# - https://jtreminio.com/blog/developing-at-full-speed-with-xdebug/#nginx-map
# - https://jtreminio.com/blog/all-in-one-php-fpm-nginx-apache-containers/
# - https://github.com/connors511/cleanup/blob/master/cleanup
# - https://engineering.shopify.com/blogs/engineering/docker-at-shopify-how-we-built-containers-that-power-over-100-000-online-shops

# Forge inspired config?
# https://gist.github.com/radermacher/e6eb26382c2bb054577c16bbeb2c6503#file-forge-sh-L216z
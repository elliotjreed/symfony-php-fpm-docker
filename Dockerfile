FROM php:8.2-fpm-alpine

LABEL Description="PHP FPM Docker image with Redis, BCMath, OPCache, APCu, Intl., PDO MySQL, MBString, and Yaml extensions." Vendor="Elliot J. Reed" Version="2.0"

ENV TZ='Europe/London'

RUN apk add --update icu yaml imagemagick libgomp libmagic && \
    apk add --no-cache --virtual .build-dependencies \
        $PHPIZE_DEPS \
        zlib-dev \
        icu-dev \
        g++ \
        libxml2-dev \
        imagemagick-dev \
        yaml-dev && \
    docker-php-ext-configure intl && \
    docker-php-ext-install bcmath pdo_mysql opcache intl && \
    pecl install -o -f yaml && \
    docker-php-ext-enable yaml && \
    pecl install apcu && \
    docker-php-ext-enable apcu && \
    pecl install -o -f redis &&  \
    docker-php-ext-enable redis && \
    pecl install -o -f imagick && \
    docker-php-ext-enable imagick && \
    docker-php-source delete && \
    { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } && \
    apk del .build-dependencies && \
    rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    chown www-data:www-data /usr/local/bin/composer && \
    chmod u+x /usr/local/bin/composer

COPY ./php-ini-overrides.ini /usr/local/etc/php/conf.d/99-overrides.ini
COPY ./fpm.conf /usr/local/etc/php-fpm.conf

WORKDIR /var/www/html

RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    touch /usr/local/var/log/php-fpm.log && \
    chmod 777 /usr/local/var/log/php-fpm.log

USER www-data

EXPOSE 9000

FROM php:fpm-alpine

LABEL Description="PHP FPM Docker image with OPCache, APCu, Intl., PDO MySQL, MBString, and Yaml extensions. Used for Symfony / Laravel applications." Vendor="Elliot J. Reed" Version="1.0"

RUN apk add --update icu yaml && \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        zlib-dev \
        icu-dev \
        g++ \
        yaml-dev && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install opcache && \
    docker-php-ext-install mbstring && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    pecl install yaml && \
    docker-php-ext-enable yaml && \
    pecl install apcu && \
    docker-php-ext-enable apcu && \
    { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } && \
    apk del .build-deps && \
    rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

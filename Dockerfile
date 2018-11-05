FROM php:fpm-alpine

LABEL Description="PHP FPM Docker image OPCache, APCu, Intl., PDO MySQL, MBString, and Yaml extensions." Vendor="Elliot J. Reed" Version="1.0"

RUN apk add --update icu yaml && \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        zlib-dev \
        icu-dev \
        g++ \
        yaml-dev && \
    docker-php-ext-install bcmath pdo_mysql iconv opcache mbstring && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    docker-php-ext-install sockets && \
    pecl install yaml && \
    docker-php-ext-enable yaml && \
    pecl install apcu && \
    docker-php-ext-enable apcu && \
    { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } && \
    apk del .build-deps && \
    rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

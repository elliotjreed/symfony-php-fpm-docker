FROM php:8.3-fpm-alpine

LABEL Description="PHP FPM Docker image with Redis, BCMath, OPCache, APCu, Intl., PDO MySQL, MBString, and Yaml extensions." Vendor="Elliot J. Reed" Version="3.0"

ENV TZ='Europe/London'

RUN apk add --update --no-cache bzip2 libzip icu icu-data-full yaml freetype libwebp libpng libjpeg-turbo imagemagick imagemagick-heic imagemagick-jpeg imagemagick-jxl imagemagick-svg imagemagick-tiff imagemagick-webp libheif libgomp libmagic && \
    apk add --update --no-cache --virtual .build-dependencies \
        $PHPIZE_DEPS \
        git \
        zlib-dev \
        icu-dev \
        icu-libs \
        g++ \
        libxml2-dev \
        imagemagick-dev \
        yaml-dev \
        libwebp-dev \
        libheif-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        bzip2-dev && \
        git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick && \
    cd /tmp/imagick && \
    git fetch origin master && \
    git switch master && \
    cd /tmp/imagick && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    docker-php-ext-enable imagick && \
    docker-php-ext-configure intl && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install bcmath pdo_mysql opcache intl fileinfo gd exif bz2 && \
    pecl install -o -f yaml && \
    docker-php-ext-enable yaml && \
    pecl install apcu && \
    docker-php-ext-enable apcu && \
    pecl install -o -f redis &&  \
    docker-php-ext-enable redis && \
    pecl install -o -f excimer && \
    docker-php-ext-enable excimer && \
    pecl clear-cache && \
    docker-php-source delete && \
    { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } && \
    apk del .build-dependencies && \
    rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/* /usr/src/php*

RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    chown www-data:www-data /usr/local/bin/composer && \
    chmod u+x /usr/local/bin/composer

COPY ./php-ini-overrides.ini /usr/local/etc/php/conf.d/99-overrides.ini
COPY ./fpm.conf /usr/local/etc/php-fpm.conf

RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    touch /usr/local/var/log/php-fpm.log && \
    chmod 777 /usr/local/var/log/php-fpm.log

WORKDIR /var/www/html

USER www-data

EXPOSE 9000


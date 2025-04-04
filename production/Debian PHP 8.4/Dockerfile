FROM php:8.4-fpm

LABEL Description="PHP FPM Docker image with Redis, BCMath, OPCache, APCu, Intl., PDO MySQL, MBString, and Yaml extensions." Vendor="Elliot J. Reed" Version="4.0"

ENV TZ='Europe/London'

# Install dependencies using apt-get instead of apk
RUN apt-get update && apt-get install -y \
    git \
    libzip-dev \
    libicu-dev \
    libfreetype6-dev \
    libwebp-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libyaml-dev \
    libmagickwand-dev \
    libheif-dev \
    libmagic-dev \
    libgomp1 \
    libbz2-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions
RUN git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick \
    && cd /tmp/imagick \
    && git fetch origin master \
    && git switch master \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install bcmath pdo_mysql opcache intl fileinfo gd exif bz2 zip \
    && pecl install -o -f yaml \
    && docker-php-ext-enable yaml \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && pecl install -o -f redis \
    && docker-php-ext-enable redis \
    && pecl install -o -f excimer \
    && docker-php-ext-enable excimer \
    && pecl clear-cache \
    && docker-php-source delete \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apt/*

# Install Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod u+x /usr/local/bin/composer

# Copy configuration files
COPY ./php-ini-overrides.ini /usr/local/etc/php/conf.d/99-overrides.ini
COPY ./fpm.conf /usr/local/etc/php-fpm.conf

# Set up the working directory with proper permissions
RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && touch /usr/local/var/log/php-fpm.log \
    && chmod 777 /usr/local/var/log/php-fpm.log

# Set working directory
WORKDIR /var/www/html

# Use non-root user
USER www-data

# Expose port
EXPOSE 9000

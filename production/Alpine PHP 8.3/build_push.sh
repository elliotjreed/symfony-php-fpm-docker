#!/bin/sh

docker build -t elliotjreed/symfony-php-fpm-docker:fpm-alpine-8.3 -t bunchesflorapost/symfony-base:fpm-alpine-8.3 . \
&& docker push elliotjreed/symfony-php-fpm-docker:fpm-alpine-8.3 \
&& docker push bunchesflorapost/symfony-base:fpm-alpine-8.3

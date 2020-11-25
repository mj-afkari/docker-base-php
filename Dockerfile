FROM php:7.4-fpm

ARG user=php
ARG uid=1000

WORKDIR /var/www


COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
    apt-get install -y  git curl libpng-dev libonig-dev libxml2-dev libzip-dev zip unzip libicu-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure intl && \
    docker-php-ext-install pdo_mysql exif pcntl bcmath gd zip intl && \
    useradd -G www-data,root -u $uid -d /home/$user $user && \
    mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

RUN pecl install redis-5.1.1 \
    && docker-php-ext-enable redis

USER $user
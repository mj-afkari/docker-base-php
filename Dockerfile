FROM php:7.4-fpm


WORKDIR /var/www


COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
    apt-get install -y  git curl libpng-dev libonig-dev libxml2-dev libzip-dev zip unzip libicu-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure intl && \
    docker-php-ext-install pdo_mysql exif pcntl bcmath gd zip intl && \
    echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini && \
    groupadd -g 1000 www && \
    useradd -u 1000 -ms /bin/bash -g www www
    

RUN pecl install redis-5.1.1 \
    && docker-php-ext-enable redis

USER www
EXPOSE 9000
CMD ["php-fpm"]

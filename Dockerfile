FROM php:8.2 as php

RUN apt-get update -y
RUN apt-get install -y unzip libpq-dev libcurl4-gnutls-dev
RUN docker-php-ext-install pdo pdo_mysql bcmath

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

RUN curl -s https://deb.nodesource.com/setup_18.x | bash
RUN apt install nodejs -y

WORKDIR /var/www
COPY . .

COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

ENV PORT=8000
ENTRYPOINT [ "Docker/entrypoint.sh" ]

# ======================================================================================
# nodejs
FROM node:18-alpine as nodejs

WORKDIR /var/www
COPY . .

RUN npm install --global cross-env
RUN npm install

VOLUME [ "/var/www/node_modules" ]
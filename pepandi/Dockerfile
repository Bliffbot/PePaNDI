# Pelican Panel Dockerfile modified to use nginx by Bliffbot

FROM node:20-alpine AS yarn

WORKDIR /build

COPY . ./

RUN yarn install --frozen-lockfile && \
    yarn run build:production

FROM php:8.3-fpm-alpine

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html

RUN apk update && \
    apk add --no-cache libpng-dev libjpeg-turbo-dev freetype-dev libzip-dev icu-dev zip unzip curl nginx ca-certificates supervisor git && \
    docker-php-ext-install bcmath gd intl zip opcache pcntl posix pdo_mysql

COPY . .

COPY --from=yarn /build/public/assets ./public/assets

RUN touch .env

RUN composer install --no-dev --optimize-autoloader

RUN rm -rf /etc/nginx && \
    mkdir /etc/nginx && \
    chmod -R 755 /var/www/html/storage && \
    chmod -R 755 /var/www/html/bootstrap/cache && \
    chown -R www-data:www-data /etc/nginx /var/www/html /var/www/html/

COPY pepandi/nginx/ /etc/nginx/

RUN echo "* * * * * php /var/www/html/artisan schedule:run >> /dev/null 2>&1" | crontab -u www-data -

RUN cp pepandi/supervisord.conf /etc/supervisord.conf && \
    mkdir /var/log/supervisord/

HEALTHCHECK --interval=5m --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/up || exit 1

EXPOSE 80

ENTRYPOINT [ "/bin/ash", "pepandi/entrypoint.sh" ]
CMD [ "supervisord", "-n", "-c", "/etc/supervisord.conf" ]

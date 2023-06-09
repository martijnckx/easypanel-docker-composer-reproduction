# composer dependencies
FROM composer:2 as vendor
WORKDIR /app
COPY composer.json .
COPY composer.lock .
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/nginx:8.1

# switch to the root user to install mysql tools
USER root
RUN apk add --no-cache mysql-client postgresql-client
USER www-data

# the user is `www-data`, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data . .
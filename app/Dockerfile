FROM php:7.3.8-fpm-alpine as builder

WORKDIR /app

COPY src/composer.json .
COPY src/composer.lock .
RUN apk update && apk add composer && composer install

COPY src .
RUN chmod 777 countlog

FROM php:7.3.8-fpm-alpine
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 9000
CMD ["php-fpm"]
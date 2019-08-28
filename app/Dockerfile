FROM bitnami/php-fpm:7.1 as builder

WORKDIR /app

COPY src/composer.json .
COPY src/composer.lock .
RUN composer install

COPY src .
RUN chmod 777 countlog

FROM bitnami/php-fpm:7.1-prod
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 9000
CMD ["php-fpm", "-F", "--pid" , "/opt/bitnami/php/tmp/php-fpm.pid", "-c", "/opt/bitnami/php/conf/php-fpm.conf"]
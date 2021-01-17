FROM alpine:3.11

RUN apk --no-cache add nginx supervisor \
    php7 php7-fpm php7-session php7-dom php7-phar php7-xmlwriter \
    php7-bcmath php7-fileinfo php7-json php7-mbstring php7-openssl php7-pdo php7-tokenizer php7-xml

COPY docker/nginx/nginx.default /etc/nginx/conf.d/default.conf
COPY docker/php-fpm/php-fpm.conf /etc/php7/php-fpm.conf
COPY docker/php-fpm/www.conf /etc/php7/php-fpm.d/www.conf
COPY docker/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY docker/supervisor/program.conf /etc/supervisor/conf.d/program.conf

WORKDIR /var/www/html
COPY . .
RUN cp .env.prod .env && \
    # php artisan config:cache && \
    # php artisan route:cache && \
    # php artisan view:cache && \
    chown -R nginx:www-data /var/www/html && \
    rm -f /etc/supervisord.conf && \
    mkdir -p /var/www/html \
             /var/log/supervisor \
             /run/nginx \
             /run/php \
             /run/supervisor

CMD ["/usr/bin/supervisord"]

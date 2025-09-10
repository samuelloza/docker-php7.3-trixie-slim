FROM php:7.3-fpm

LABEL maintainer="Samuel Loza <samuel.loza26@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev libicu-dev libpng-dev libjpeg-dev libpq-dev \
    libmagickwand-dev git unzip curl \
 && docker-php-ext-install \
    pdo_mysql pdo_pgsql mysqli intl bcmath zip mbstring opcache \
    xml \
 && docker-php-ext-configure gd --with-jpeg \
 && docker-php-ext-install gd \
 && pecl install imagick \
 && docker-php-ext-enable imagick \
 && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer

RUN sed -ri 's|^listen = .*|listen = 0.0.0.0:9000|' /usr/local/etc/php-fpm.d/zz-docker.conf

WORKDIR /var/www
VOLUME ["/var/www"]

EXPOSE 9000
CMD ["php-fpm"]

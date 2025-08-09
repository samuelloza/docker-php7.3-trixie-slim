FROM debian:trixie-slim

LABEL maintainer="Samuel Loza <samuel.loza26@gmail.com>"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
  apt-get install -y --no-install-recommends ca-certificates curl gnupg git unzip; \
  mkdir -p /usr/share/keyrings; \
  curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/sury-php.gpg; \
  echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php trixie main" \
    > /etc/apt/sources.list.d/sury-php.list; \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update; \
  apt-get install -y --no-install-recommends \
    php7.3 php7.3-fpm php7.3-cli \
    php7.3-mbstring php7.3-xml php7.3-zip \
    php7.3-curl php7.3-opcache php7.3-intl php7.3-bcmath \
    php7.3-mysql php7.3-pgsql php7.3-sqlite3 \
    php7.3-gd php7.3-imagick; \
  rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer

RUN sed -ri 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.3/fpm/pool.d/www.conf; \
  mkdir -p /run/php

WORKDIR /var/www
VOLUME ["/var/www"]

EXPOSE 9000
CMD ["php-fpm7.3", "-F"]

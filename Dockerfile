FROM php:8.2-fpm-bullseye

LABEL framework="Wordpress"
LABEL environment="development"
LABEL maintainer="Koderlab"
LABEL team="Kolibra Team"
LABEL description="Skeleton for Wordpress application, uses php-fpm sock listening daemon, /var/www/html/ as main Wordpress directory and wordpress:wordpress user as owner."

# Add wordpress user
RUN groupadd -g 1000 wordpress \
    && useradd -g 1000 -u 1000 -s /bin/bash -d /var/www/ wordpress
RUN chown wordpress:wordpress -R /var/www/

# Install system libraries
RUN apt-get update && apt-get install -y \
    procps lsof ca-certificates gnupg zip \
    zlib1g-dev libpng-dev libwebp-dev libjpeg62-turbo-dev libfreetype6-dev libbz2-dev libicu-dev libonig-dev libxml2-dev libsodium-dev libxslt-dev libzip-dev \
    cron net-tools iputils-ping msmtp libfcgi-dev \
    wget curl vim mc watch jq locales \
      && rm -rf /var/lib/apt/lists/*

# Install and configure PHP libraries
RUN docker-php-ext-configure \
    gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    soap \
    sockets \
    sodium \
    sysvmsg \
    sysvsem \
    sysvshm \
    xsl \
    zip

# Copy config files
COPY ./conf/php-fpm/etc/php/php.ini              /usr/local/etc/php/php.ini
COPY ./conf/php-fpm/etc/php-fpm.conf             /usr/local/etc/php-fpm.conf
COPY ./conf/php-fpm/etc/php-fpm.d/www.conf       /usr/local/etc/php-fpm.d/www.conf
COPY ./conf/php-fpm/etc/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

# Final settings
#EXPOSE 9000

WORKDIR /var/www/html

ENTRYPOINT ["docker-php-entrypoint"]

CMD ["php-fpm"]

# Production stage
FROM php:7.2-fpm-alpine AS app_php

# UID/GID handling
ARG USER_UID=1000
ARG USER_GID=1000

RUN apk update && apk add --no-cache \
    shadow \
    acl \
    fcgi \
    file \
    gettext \
    git \
    icu-dev \
    libzip-dev \
    zlib-dev \
    libpng-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    postgresql-dev

# php extensions installer: https://github.com/mlocati/docker-php-extension-installer
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions \
    gd \
    intl \
    pdo_pgsql \
    pgsql \
    zip \
    opcache \
    apcu

# User setup to match host UID/GID
RUN groupmod -g $USER_GID www-data && \
    usermod -u $USER_UID -g www-data www-data

WORKDIR /srv/app

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

# PHP-FPM socket configuration
COPY docker/php/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
RUN mkdir -p /var/run/php && chown www-data:www-data /var/run/php

COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

# Development stage
FROM app_php AS app_php_dev

RUN install-php-extensions xdebug-2.9.8

ENV APP_ENV=dev

FROM php:7.4.6-fpm-buster

# используем apt-get вместо apt, чтобы не получать: WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

RUN apt-get update

# чтобы при установке apt-пакетов не возникало предупреждения: debconf: delaying package configuration, since apt-utils is not installed
RUN apt install -y apt-utils

RUN apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

# основные утилиты
RUN apt-get install -y \
        wget \
        curl \
        git \
        vim \
        sudo \
        telnet \
        net-tools

# used for validators (symfony)
RUN apt-get install -y libicu-dev
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

# Install xdebug extension
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Чтобы composer install не выдавал ошибку: Failed to download symfony/stopwatch from dist: The zip extension and unzip command are both missing, skipping.
RUN apt-get install -y \
    zip \
    libzip-dev
RUN docker-php-ext-configure zip \
    && docker-php-ext-install zip

RUN pecl install apcu && \
    docker-php-ext-enable apcu

# mysql
RUN docker-php-ext-install mysqli pdo_mysql

# Install composer + create composer home dir для пользователя www-data
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin \
 && mv /usr/bin/composer.phar /usr/bin/composer

RUN mkdir /var/www/.composer && chown www-data:www-data /var/www/.composer

# only for dev:
# чтобы пользователь www-data мог выполнять sudo команды:
RUN usermod -aG sudo www-data && echo "www-data:123456"|chpasswd

# мы клонируем репозиторий под пользователем c id=1000, а значит чтобы с помощью пользователя www-data взаимодействовать
# с файлами/директориями пользовать с id=1000 должен быть в контейнере.
RUN useradd -ms /bin/bash -p "`openssl passwd -1 123456`" -G sudo,www-data user

# чтобы пользователь www-data имел доступ к директориям/файлам созданным пользователем user(1000):
RUN usermod -aG user www-data

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

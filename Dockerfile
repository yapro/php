# данный файл скопирован с https://github.com/yapro/php/blob/7.4.6-fpm-buster/Dockerfile
# после сильно изменен https://github.com/yapro/api-platform-understanding/blob/d327d6300793bcce825ccc29727b12738eb79be0/Dockerfile
# еще раз сильно изменен и теперь имеет такой вид:
FROM php:7.4.16-fpm-buster

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
RUN pecl install apcu && \
    docker-php-ext-enable apcu

# mysql
RUN docker-php-ext-install mysqli pdo_mysql

# Чтобы composer install не выдавал ошибку: Failed to download symfony/stopwatch from dist: The zip extension and unzip command are both missing, skipping.
RUN apt-get install -y \
    zip \
    libzip-dev
RUN docker-php-ext-configure zip \
    && docker-php-ext-install zip

# Install composer
RUN curl https://getcomposer.org/download/2.0.12/composer.phar --output /usr/bin/composer && \
    chmod +x /usr/bin/composer

# мне удобно править библиотеки сразу в директории vendor, но чтобы composer смог устанавливать библиотеки из сорцов, composer-у нужен гит
RUN apt-get install -y git

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# мне удобно в докер-контейнере иметь те же права, что и на хост-машине, поэтому создаю подобного пользователя в контейнере
ENV UID=1000
ENV GID=1000
ENV USER=www-data
ENV GROUP=www-data

# директория /tmp/home указана потому, что когда разработчик использует ssh-агента, то в этой директории создаются файлы
RUN usermod -u $UID $USER --home /tmp/home && groupmod -g $GID $GROUP
USER $USER

ENV COMPOSER_HOME=/tmp/composer-home
RUN mkdir $COMPOSER_HOME
# Сохраняем конфигурацию глобально в файле: $COMPOSER_HOME/config.json
RUN composer config --global "preferred-install.yapro/*" source
# Check alternative: composer update yapro/* --prefer-source

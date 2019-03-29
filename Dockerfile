FROM php:7.1-fpm-stretch

RUN apt-get update 

RUN apt-get install -y git nano locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

RUN docker-php-ext-install pdo

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp && git clone -b '1.1.20' --single-branch https://github.com/yiisoft/yii.git --recursive yii

RUN mkdir -p /tmp/yii/WebRoot/testdrive

RUN cd /tmp/yii && yes | php framework/yiic webapp WebRoot/testdrive

# Add default user
RUN useradd -ms /bin/bash -p "`openssl passwd -1 123456`" -G sudo,www-data user

# Install xdebug extension
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini

COPY . /tmp/

RUN cp /tmp/console.php /tmp/yii/WebRoot/testdrive/protected/config/console.php && \
    cp /tmp/User.php /tmp/yii/WebRoot/testdrive/protected/models/User.php && \
    cp /tmp/MybugCommand.php /tmp/yii/WebRoot/testdrive/protected/commands/MybugCommand.php

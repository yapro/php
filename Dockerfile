FROM debian:jessie

MAINTAINER Lebedenko Nikolay <lebnikpro@gmail.com>

RUN apt-get update \
 && apt-get install -y \
 curl \
 ca-certificates \
 software-properties-common \
 python-software-properties \
 nano \
 git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update \
 && apt-get install -y \
 php5-cli \
 php5-fpm \
 php5-gd \
 php5-apcu \
 php5-curl \
 php5-intl \
 php5-mysql \
 php5-mcrypt \
 php5-imagick \
 php5-xdebug \
 --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN unlink /etc/php5/fpm/conf.d/20-readline.ini \
 && unlink /etc/php5/fpm/conf.d/20-xdebug.ini \
 && unlink /etc/php5/cli/conf.d/20-xdebug.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin && mv /usr/bin/composer.phar /usr/bin/composer

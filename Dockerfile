FROM php:5.6-fpm

MAINTAINER Lebedenko Nikolay <lebnikpro@gmail.com>

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin && mv /usr/bin/composer.phar /usr/bin/composer

RUN apt-get update \
 && apt-get install -y nano git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
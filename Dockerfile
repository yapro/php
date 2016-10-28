FROM php:5.6-fpm

MAINTAINER Lebedenko Nikolay <lebnikpro@gmail.com>

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin && mv /usr/bin/composer.phar /usr/bin/composer
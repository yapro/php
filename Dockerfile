FROM ubuntu:12.04

MAINTAINER Lebedenko Nikolay <lebnikpro@gmail.com>

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
 git \
 nano \
 curl \
 ca-certificates \
 software-properties-common \
 python-software-properties \
 tzdata \
 php5-cli \
 php5-fpm \
 php5-intl \
 php5-mysql \
 php5-xdebug \
 php5-imagick \
 php5-gd \
 php5-curl \
 php5-mcrypt \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin \
 && mv /usr/bin/composer.phar /usr/bin/composer

RUN unlink /etc/php5/conf.d/xdebug.ini

CMD ["/usr/sbin/php5-fpm", "-F"]
FROM debian:jessie

MAINTAINER Lebedenko Nikolay <lebnikpro@gmail.com>

RUN apt-get update \
 && apt-get install -y curl ca-certificates software-properties-common python-software-properties \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update \
 && apt-get install -y nano git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PHP_VERSION=5.6.24

RUN apt-get update \
 && apt-get install -y tzdata locales-all \
 "php5-cli=$PHP_VERSION+*" \
 "php5-fpm=$PHP_VERSION+*" \
 "php5-curl=$PHP_VERSION+*" \
 "php5-pgsql=$PHP_VERSION+*" \
 "php5-gd=$PHP_VERSION+*" \
 "php5-intl=$PHP_VERSION+*" \
 php5-gd \
 php5-mysql \
 php5-mongo \
 php5-memcache \
 php5-apcu \
 php5-xdebug \
 php5-imagick \
 php5-mcrypt \
 php5-xhprof \
 php5-memcached \
 php-amqplib \
 --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN unlink /etc/php5/fpm/conf.d/20-xdebug.ini \
 && unlink /etc/php5/cli/conf.d/20-xdebug.ini

ADD php.ini /etc/php5/fpm/conf.d/php.ini
ADD php.ini /etc/php5/cli/conf.d/php.ini

RUN apt-get update \
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin \
 && mv /usr/bin/composer.phar /usr/bin/composer \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/sbin/php5-fpm", "-F"]

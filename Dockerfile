FROM ubuntu:14.04

MAINTAINER Lebedenko Nikolay <lebnikpro@gmail.com>

# Add libraries directory
ADD ./lib /home/lib

##########################
## INSTALL DEPENDENCIES ##
##########################

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	autoconf \
	build-essential \
	imagemagick \
	libgd3 \
	libgd-dev \
	mcrypt \
	libmcrypt-dev \
	libbz2-dev \
	libcurl4-openssl-dev \
	libevent-dev \
	libffi-dev \
	libglib2.0-dev \
	libjpeg-dev \
	libmagickcore-dev \
	libmagickwand-dev \
	libmysqlclient-dev \
	libncurses-dev \
	libpq-dev \
	libreadline-dev \
	libsqlite3-dev \
	libssl-dev \
	libxml2-dev \
	libxslt-dev \
	libyaml-dev \
	zlib1g-dev \
	msmtp

# Build and install PHP
WORKDIR /home/lib
RUN tar -xvf php-5.3.29.tar.gz
WORKDIR /home/lib/php-5.3.29
RUN ./configure --enable-fpm --with-mysql --with-mysqli --with-zlib --with-jpeg-dir --with-gd --with-curl --with-openssl --with-pdo-mysql --with-mcrypt  --enable-mbstring=all
RUN make clean
RUN make
RUN make install
RUN cp sapi/fpm/php-fpm /usr/local/bin

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && rm -rf /home/lib

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin && mv /usr/bin/composer.phar /usr/bin/composer

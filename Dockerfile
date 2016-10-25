FROM debian:jessie
MAINTAINER Lebedenko Nikolay <lebnikpro@gmail.com>
#OLD MAINTAINER Tom Hill <tom@greensheep.io>

##########################
## INSTALL DEPENDENCIES ##
##########################

# Install packages
RUN DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
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
	libicu-dev

##########################
# Build and install PHP
##########################

# Add libraries directory
ADD ./lib /home/lib
WORKDIR /home/lib
RUN tar -xvf php-5.3.29.tar.gz
WORKDIR /home/lib/php-5.3.29
RUN mkdir /usr/include/freetype2/freetype
#RUN ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h
RUN ./configure \
 --enable-fpm \
 --with-mysql \
 --with-mysqli \
 --with-pdo-mysql \
 --with-zlib \
 --with-gd \
 --with-jpeg-dir \
 --with-curl \
 --with-openssl \
 --with-mcrypt \
 --enable-intl \
 --with-iconv \
 --with-iconv-dir \
 --enable-mbstring=all
# --with-xsl \
# --with-freetype-dir \
RUN make clean
RUN make
RUN make install
RUN cp sapi/fpm/php-fpm /usr/local/bin
CMD ["php5-fpm", "-F"]

RUN && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

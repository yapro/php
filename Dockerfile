FROM php:7.1-fpm

RUN apt-get update && apt-get install -y \
        git \
        vim \
        sudo \
        telnet \
        bzip2 \
        libbz2-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libghc-postgresql-libpq-dev \
        libxml2-dev \
        libicu-dev \
	    libldap2-dev \
        && docker-php-ext-install mcrypt mbstring bz2 zip soap bcmath \
        && docker-php-ext-configure gd -with-freetype-dir=/usr/include/ -with-jpeg-dir=/usr/include/ \
        && docker-php-ext-configure pgsql -with-pgsql=/usr/include/postgresql/ \
	    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
	    && docker-php-ext-configure intl \
        && docker-php-ext-install gd pgsql pdo_pgsql pdo_mysql sockets ldap intl

RUN sed -i "s/pm.max_children = .*/pm.max_children = 200/" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/pm.start_servers = .*/pm.start_servers = 20/" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/pm.min_spare_servers = .*/pm.min_spare_servers = 20/" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/pm.max_spare_servers = .*/pm.max_spare_servers = 30/" /usr/local/etc/php-fpm.d/www.conf

#RUN apt-get update && apt-get install -y librdkafka-dev \
#    && pecl install channel://pecl.php.net/rdkafka-1.0.0 \
#    && docker-php-ext-enable rdkafka

#Install composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer \
    && useradd -ms /bin/bash -p "`openssl passwd -1 123456`" -G sudo,www-data user

RUN apt-get update && apt-get install -y libmemcached-dev \
    && pecl install mongodb \
#    && pecl install memcached \
#    && pecl install channel://pecl.php.net/xhprof-0.9.3 \
    && docker-php-ext-enable mongodb
#    && docker-php-ext-enable memcached mongodb xhprof

RUN apt-get update && apt-get install -y wget libmemcached-dev zlib1g-dev

RUN cd /tmp \
    && git clone https://github.com/php-memcached-dev/php-memcached.git \
    && cd php-memcached \
    && phpize \
    && ./configure \
    && make \
    && make install

RUN set -xe \
        && mkdir /tmp/msodbcubuntu \
        && wget ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.1.tar.gz -P /tmp/msodbcubuntu/ \
        && cd /tmp/msodbcubuntu \
        && tar -xzf /tmp/msodbcubuntu/unixODBC-2.3.1.tar.gz \
        && cd /tmp/msodbcubuntu/unixODBC-2.3.1/ \
        && export CPPFLAGS="-DSIZEOF_LONG_INT=8" \
        && ./configure --prefix=/usr --libdir=/usr/lib64 --sysconfdir=/etc --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=utf8 --with-iconv-ucode-enc=UTF16LE \
        && make install

RUN set -xe \
        && wget "https://meetsstorenew.blob.core.windows.net/contianerhd/Ubuntu%2013.0%20Tar/msodbcsql-13.0.0.0.tar.gz?st=2016-10-18T17%3A29%3A00Z&se=2022-10-19T17%3A29%3A00Z&sp=rl&sv=2015-04-05&sr=b&sig=cDwPfrouVeIQf0vi%2BnKt%2BzX8Z8caIYvRCmicDL5oknY%3D"  -O /tmp/msodbcubuntu/msodbcsql-13.0.0.0.tar.gz \
        && cd /tmp/msodbcubuntu/ \
        && tar xvfz /tmp/msodbcubuntu/msodbcsql-13.0.0.0.tar.gz \
        && cd /tmp/msodbcubuntu/msodbcsql-13.0.0.0/ \
        && ldd /tmp/msodbcubuntu/msodbcsql-13.0.0.0/lib64/libmsodbcsql-13.0.so.0.0 \
        && echo "/usr/lib64" >> /etc/ld.so.conf \
        && ldconfig \
        && ./install.sh install --force --accept-license \
        && rm -rf /tmp/msodbcubuntu

RUN apt-get update && apt-get install -y libgss3 locales \
        && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

RUN set -xe \
        && pecl install --nocompress sqlsrv-4.1.6.1 \
        && pecl install --nocompress pdo_sqlsrv-4.1.6.1 \
        && docker-php-ext-enable sqlsrv pdo_sqlsrv memcached
RUN set -xe \
        && wget --no-check-certificate "https://meetsstorenew.blob.core.windows.net/contianerhd/Ubuntu%2013.0%20Tar/msodbcsql-13.0.0.0.tar.gz?st=2016-10-18T17%3A29%3A00Z&se=2022-10-19T17%3A29%3A00Z&sp=rl&sv=2015-04-05&sr=b&sig=cDwPfrouVeIQf0vi%2BnKt%2BzX8Z8caIYvRCmicDL5oknY%3D"  -O /tmp/msodbcubuntu/msodbcsql-13.0.0.0.tar.gz \
        && cd /tmp/msodbcubuntu/ \
        && tar xvfz /tmp/msodbcubuntu/msodbcsql-13.0.0.0.tar.gz \
        && cd /tmp/msodbcubuntu/msodbcsql-13.0.0.0/ \
        && ldd /tmp/msodbcubuntu/msodbcsql-13.0.0.0/lib64/libmsodbcsql-13.0.so.0.0 \
        && echo "/usr/lib64" >> /etc/ld.so.conf \
        && ldconfig \
        && ./install.sh install --force --accept-license \
        && rm -rf /tmp/msodbcubuntu

RUN apt-get update && apt-get install -y libgss3 locales \
        && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

RUN set -xe && pecl install --nocompress sqlsrv-4.1.6.1
RUN set -xe && pecl install --nocompress pdo_sqlsrv-4.1.6.1
RUN set -xe && docker-php-ext-enable sqlsrv pdo_sqlsrv memcached

RUN wget http://xdebug.org/files/xdebug-2.5.4.tgz -O /tmp/xdebug-2.5.4.tgz \
    && cd /tmp \
    && tar -xvzf xdebug-2.5.4.tgz \
    && cd xdebug-2.5.4 \
    && phpize \
    && ./configure \
    && make \
    && cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

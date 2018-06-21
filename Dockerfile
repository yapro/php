FROM php:7.1-fpm-stretch

RUN apt-get update 

RUN apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

RUN apt-get install -y \
        wget \
        git \
        vim \
        sudo \
        telnet \
        bzip2 \
        libbz2-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libghc-postgresql-libpq-dev \
        libxml2-dev \
        libicu-dev \
        libldap2-dev \
        gnupg \
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

#Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/bin/composer \
    && useradd -ms /bin/bash -p "`openssl passwd -1 123456`" -G sudo,www-data user

# Install memcached extension
RUN apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached

# Install mongodb extension
RUN apt-get install -y zlib1g-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

# Install Microsoft ODBC Driver
RUN curl -k https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get install -y apt-transport-https \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Install sqlserver extension
RUN apt-get install -y unixodbc-dev \
    && pecl install sqlsrv-5.2.0 pdo_sqlsrv-5.2.0 \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Install xdebug extension
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM ubuntu:16.04
MAINTAINER Yuriy Maslennikov <maslennikovyv@gmail.com>

VOLUME ["/var/www"]

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
      apache2 \
      php \
      php-dev \
      php-cli \
      libapache2-mod-php \
      php-gd \
      php-json \
      php-ldap \
      php-mbstring \
      php-memcache \
      php-mysql \
      php-pgsql \
      php-sqlite3 \
      php-xml \
      php-xsl \
      php-zip \
      php-soap \
      wget \
      g++ \
      make \
      libgss3 \
      locales

RUN locale-gen en_US.UTF-8 && locale-gen ru_RU.UTF-8 && locale-gen ru ru_RU.CP1251
ENV LANG='ru_RU.UTF-8' LANGUAGE='ru_RU:ru' LC_ALL='ru_RU.UTF-8'

#COPY apache_default /etc/apache2/sites-available/000-default.conf
COPY run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
RUN a2enmod rewrite speling

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

COPY docker-php-ext-* /usr/local/bin/

RUN set -xe \
	&& chmod +x /usr/local/bin/docker-php-ext-* \
	&& pecl install sqlsrv-4.0.8 \
	&& pecl install pdo_sqlsrv-4.0.8 \
	&& docker-php-ext-enable sqlsrv pdo_sqlsrv

EXPOSE 80
CMD ["/usr/local/bin/run"]

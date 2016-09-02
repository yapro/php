FROM centos:7.2.1511

MAINTAINER Lebedenko Nikolay <lebnikpro@gmail.com>

# some time need execute: yum -y install initscripts which
# centos commands : https://habrahabr.ru/post/301292/
# centos php 7 :    https://codebeer.ru/ustanovka-php-7-v-centos-7/

RUN yum check-update ; echo "updated"

RUN yum update -y \
 && yum install -y nano mercurial.x86_64

# -- install php7 \
RUN yum install -y epel-release.noarch
RUN rpm --import http://rpms.remirepo.net/RPM-GPG-KEY-remi
RUN rpm -Uhv http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum check-update ; echo "updated"

RUN yum install -y \
 php70-php-cli.x86_64 \
 php70-php-pecl-apcu.x86_64 \
 php70-php-intl.x86_64 \
 php70-php-pecl-zip.x86_64 \
 php70-php-fpm.x86_64 \
 php70-php-devel.x86_64 \
 php70-runtime.x86_64 \
 php70-php-common.x86_64 \
 php70.x86_64 \
 php70-php-pdo.x86_64 \
 php70-php-pecl-apcu.x86_64 \
 php70-php-xml.x86_64 \
 php70-php-pear.noarch \
 php70-php-mysqlnd.x86_64 \
 php70-php-opcache.x86_64 \
 php70-php-imap.x86_64 \
 php70-php-mbstring.x86_64 \
 php70-php-gd.x86_64 \
 php70-php-gmp.x86_64 \
 php70-php-json.x86_64 \
 php70-php-process.x86_64 \
 php70-php-pecl-imagick.x86_64 \
 php70-php-pgsql.x86_64 \
 php70-php-bcmath.x86_64 \
 php70-php.x86_64 \
 php70-php-soap.x86_64 \
 php70-php-pecl-xdebug.x86_64

RUN unlink /etc/opt/remi/php70/php.d/15-xdebug.ini

RUN ln -sf /usr/bin/php70 /usr/bin/php \
 && yum clean all

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin \
 && mv /usr/bin/composer.phar /usr/bin/composer

RUN groupadd www-data \
 &&useradd -g www-data -s /bin/bash -p xxxx -d /home/www-data -m www-data

# cat /usr/lib/systemd/system/php70-php-fpm.service
CMD ["/opt/remi/php70/root/usr/sbin/php-fpm", "-F"]

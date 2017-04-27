# Docker file for build container with php 7.1

```
docker run --rm -i -t centos:7.2.1511 bash
```

Check php version:
```
yum install -y epel-release.noarch remi-release-7.2-1.el7.remi.noarch && \
rpm --import http://rpms.remirepo.net/RPM-GPG-KEY-remi && \
rpm -Uhv http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
yum check-update && \
yum info php71-php-cli.x86_64
```

Got info:
```
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
* base: mirror.logol.ru
* epel: mirror.logol.ru
* extras: mirror.logol.ru
* remi-safe: mirror.awanti.com
* updates: mirror.logol.ru
Available Packages
Name        : php71-php-cli
Arch        : x86_64
              Version     : 7.1.4
              Release     : 1.el7.remi
              Size        : 3.0 M
Repo        : remi-safe
Summary     : Command-line interface for PHP
URL         : http://www.php.net/
License     : PHP and Zend and BSD and MIT and ASL 1.0
Description : The php71-php-cli package contains the command-line interface
: executing PHP scripts, /opt/remi/php71/root/usr/bin/php, and the CGI interface.
```
# Docker file for build container with php 7.0

```
docker run --rm -i -t centos:7.2.1511 bash
```

Check php version:
```
yum install -y epel-release.noarch remi-release-7.2-1.el7.remi.noarch && \
rpm --import http://rpms.remirepo.net/RPM-GPG-KEY-remi && \
rpm -Uhv http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
yum check-update && \
yum info php70-php-cli.x86_64
```

Got info:
```
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
* base: mirror.logol.ru
* epel: mirror.logol.ru
* extras: mirror.logol.ru
* remi-safe: mirror.23media.de
* updates: mirror.logol.ru
Installed Packages
Name        : php70-php-cli
Arch        : x86_64
              Version     : 7.0.10
              Release     : 1.el7.remi
              Size        : 8.2 M
Repo        : installed
From repo   : remi-safe
Summary     : Command-line interface for PHP
URL         : http://www.php.net/
            License     : PHP and Zend and BSD
            Description : The php70-php-cli package contains the command-line interface
            : executing PHP scripts, /opt/remi/php70/root/usr/bin/php, and the
            : CGI interface.

Available Packages
Name        : php70-php-cli
Arch        : x86_64
Version     : 7.0.19
Release     : 1.el7.remi
Size        : 2.6 M
Repo        : remi-safe
Summary     : Command-line interface for PHP
            URL         : http://www.php.net/
            License     : PHP and Zend and BSD and MIT and ASL 1.0
            Description : The php70-php-cli package contains the command-line interface
: executing PHP scripts, /opt/remi/php70/root/usr/bin/php, and the
: CGI interface.
```

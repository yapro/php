FROM php:7.1-fpm-stretch

COPY . /tmp

RUN apt-get update 

RUN apt-get install -y git nano locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

RUN docker-php-ext-install pdo

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp && git clone -b '1.1.20' --single-branch https://github.com/yiisoft/yii.git --recursive yii

RUN mkdir -p /tmp/yii/WebRoot/testdrive

RUN cd /tmp/yii && yes | php framework/yiic webapp WebRoot/testdrive

FROM php:5.6-fpm
MAINTAINER Plopix

RUN apt-get update -q -y && apt-get install -q -y --force-yes --no-install-recommends build-essential libxml2-dev libmemcached-dev libssl-dev libfreetype6-dev \
    libcurl4-openssl-dev libmagickwand-dev libmagickcore-dev libjpeg62-turbo-dev libmcrypt-dev libxpm-dev libpng12-dev libicu-dev libxslt1-dev ca-certificates openssl \
    mysql-client python openssh-client default-jre curl nodejs unzip git imagemagick wget && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /root/.ssh && ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts

RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-xpm-dir=/usr/include/ --enable-gd-native-ttf --enable-gd-jis-conv && \
    echo "autodetect" | pecl install imagick && \
    echo "yes  --disable-memcached-sasl" | pecl install memcached && \
    echo "no" | pecl install mongodb mongo && \
    docker-php-ext-enable memcached mongodb mongo opcache && \
    docker-php-ext-install mysql mysqli pdo_mysql iconv mcrypt exif gd pcntl intl curl xsl xml json zip

CMD ["php-fpm"]

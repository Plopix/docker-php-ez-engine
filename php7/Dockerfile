FROM php:7-fpm
MAINTAINER Plopix

RUN apt-get update -q -y && apt-get install -q -y --force-yes --no-install-recommends build-essential libxml2-dev libmemcached-dev libmemcached11 libssl-dev libfreetype6-dev rsync \
    libcurl4-openssl-dev libmagickwand-dev libmagickcore-dev libjpeg62-turbo-dev libmcrypt-dev libxpm-dev libpng12-dev libicu-dev libxslt1-dev ca-certificates openssl \
    mysql-client python openssh-client default-jre curl nodejs unzip git imagemagick wget && \
    update-alternatives --install /usr/bin/node nodejs /usr/bin/nodejs 100 && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /root/.ssh && ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts

RUN git clone https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached && cd /usr/src/php/ext/memcached && git checkout -b php7 origin/php7 \
    && docker-php-ext-configure memcached && docker-php-ext-install memcached

RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-xpm-dir=/usr/include/ --enable-gd-native-ttf --enable-gd-jis-conv && \
    echo "autodetect" | pecl install imagick && \
    echo "no" | pecl install mongodb && \
    pecl install redis-3.1.1 && \
    docker-php-ext-enable memcached mongodb opcache imagick redis && \
    docker-php-ext-install mysqli pdo_mysql iconv mcrypt exif gd pcntl intl curl xsl xml json zip

RUN curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") && \
    tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp && \
    mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so && rm /tmp/blackfire-probe.tar.gz

CMD ["php-fpm"]

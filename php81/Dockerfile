FROM php:8.1-fpm

RUN mkdir -p /usr/share/man/man1 && apt-get update -q -y && apt-get install -q -y --no-install-recommends build-essential libxml2-dev libmemcached-dev libmemcached11 libssl-dev libfreetype6-dev rsync \
    libcurl4-openssl-dev libzip-dev libmagickwand-dev libmagickcore-dev libjpeg62-turbo-dev libmcrypt-dev libxpm-dev libpng-dev libicu-dev libxslt1-dev ca-certificates openssl \
    default-mysql-client python openssh-client default-jre default-jre-headless curl unzip git imagemagick wget gnupg jpegoptim && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /root/.ssh && ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts

RUN curl -s https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -q -y --no-install-recommends nodejs && npm install -g uglify-js && npm install -g uglifycss

ADD http://pngquant.org/pngquant-2.17.0-src.tar.gz /usr/src
RUN cd /usr/src && \
    tar xvzf pngquant-2.17.0-src.tar.gz && \
    cd pngquant-2.17.0 && make && make install && \
    cd .. && rm pngquant-2.17.0-src.tar.gz && rm -rf pngquant-2.17.0

RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-xpm && \
    echo "autodetect" | pecl install imagick && \
    echo "no" | pecl install mongodb && \
    echo "no" | pecl install redis && \
    echo "no" | pecl install memcached && \
    pecl install xdebug && \
    docker-php-ext-enable memcached mongodb opcache imagick redis && \
    docker-php-ext-install mysqli pdo_mysql exif gd pcntl

RUN docker-php-ext-install intl xsl zip

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") && \
     architecture=$(uname -m) && \
     curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/$architecture/$version && \
     tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp && \
     mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so && rm /tmp/blackfire-probe.tar.gz

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -q -y && apt-get install -q -y --no-install-recommends yarn && \
    apt-get clean

CMD ["php-fpm"]

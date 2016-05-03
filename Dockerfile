FROM php:5.6-fpm-alpine
MAINTAINER Plopix

# Install PHP Extensions
RUN apk --update add libtool imagemagick-dev imagemagick libmemcached-dev libmemcached libmemcached-libs \
    zlib-dev php-cli php-curl php-pdo_mysql php-mysqli php-gd php-exif php-intl php-json php-mcrypt php-mysql php-xsl openssl openssl-dev && \
    echo "autodetect" | pecl install imagick && \
    echo "yes  --disable-memcached-sasl" | pecl install memcached && \
    pecl install mongodb mongo zip apcu

# MySQL client, even node.. for frontend compile scripts that run on the engine
RUN apk add mysql-client python openssh-client nodejs git && mkdir -p /root/.ssh && ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts

# Enable PHP Extensions
RUN ln -s /usr/lib/php/modules/mcrypt.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/ && \
    ln -s /usr/lib/php/modules/gd.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/ && \
    ln -s /usr/lib/php/modules/intl.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/ && \
    ln -s /usr/lib/php/modules/xsl.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/ && \
    ln -s /usr/lib/php/modules/pdo_mysql.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/ && \
    ln -s /usr/lib/php/modules/mysql.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/ && \
    ln -s /usr/lib/php/modules/mysqli.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/ && \
    ln -s /usr/lib/php/modules/exif.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/

CMD ["php-fpm"]

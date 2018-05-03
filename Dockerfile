FROM php:fpm-alpine

# change apk update resource to CN mirror
COPY ./repositories /etc/apk/repositories

# set php post file size
COPY ./upload.ini /usr/local/etc/php/conf.d/upload.ini

RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
    # config gd
    docker-php-ext-configure gd \
     --with-gd \
     --with-freetype-dir=/usr/include/ \
     --with-png-dir=/usr/include/ \
     --with-jpeg-dir=/usr/include/ && \
    # get cpu core count , -c is grep count line as begin with processor line
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    # install gd
    docker-php-ext-install -j${NPROC} gd && \
    # wtf ?
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev && \
    # install pdo
    docker-php-ext-install pdo_mysql

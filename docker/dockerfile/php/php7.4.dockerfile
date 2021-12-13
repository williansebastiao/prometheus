FROM php:7.4-fpm

ARG user=ethos
ARG uid=1000

RUN apt-get update && apt-get install -y \
    build-essential \
    supervisor \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    tar \
    wget \
    nano \
    vim \
    make \
    sudo \
    openssl \
    libssl-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd && \
    pecl install mongodb  && \
    echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongo.ini

RUN apt-get update && apt-get install -y \
    libzip-dev && \
    docker-php-ext-install zip

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo_mysql mbstring iconv gd
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

WORKDIR /var/www/app

USER $user
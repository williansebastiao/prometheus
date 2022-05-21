FROM php:8.1-fpm

ARG user=ethos
ARG uid=1000

# install extensions
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    nodejs \
    npm \
    git \
    curl \
    build-essential \
    python3.4 \
    python3-pip \
    libonig-dev \
    libxml2-dev \
    tar \
    wget \
    nano \
    cron \
    make \
    sudo \
    openssl \
    unzip \
    chromium \
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

# config extension gd
RUN apt-get update && apt-get install -y \
    libzip-dev && \
    docker-php-ext-install zip

# docker install extensions
RUN docker-php-ext-install pdo_mysql mbstring iconv

# supervisor
RUN pip install supervisor
RUN echo_supervisord_conf > /etc/supervisord.conf

# clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# install xdebug
RUN pecl install xdebug

# install puppeteer globaly
RUN npm install puppeteer --global

# install yarn
RUN npm install -g yarn

# install composer
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# permission folder
RUN chown -R www-data:www-data /var/www
RUN chmod -R 777 /var/www

# change memory php to 512m
RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

WORKDIR /var/www/app
USER $user

EXPOSE 9000

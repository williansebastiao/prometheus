FROM php:7.4-fpm

ARG user=ethos
ARG uid=1000

# install extensions
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    npm \
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

# install packages to use sql server
RUN apt-get update && apt-get install -y gnupg2
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list 
RUN apt-get update 
RUN ACCEPT_EULA=Y apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev 
RUN pecl install sqlsrv pdo_sqlsrv
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

# install xdebug
RUN pecl install xdebug

# install puppeteer globaly
RUN npm install puppeteer --global

# install node version 14.x
# RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - 
# RUN apt-get install -y nodejs

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y \
    yarn

# install composer
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo_mysql mbstring iconv gd
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# change memory php to 512m
RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

WORKDIR /var/www/app
USER $user
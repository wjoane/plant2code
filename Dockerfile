FROM php:8.0.1-fpm-buster

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/plant2code/

# Set working directory
WORKDIR /var/www/plant2code

# Needed to install default-jre which comes with man pages
RUN mkdir -p /usr/share/man/man1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    default-jre

# Clear cache
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pecl install xdebug && docker-php-ext-enable xdebug

# Get latest Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for crawler application and set permissions
RUN groupadd -g 1000 plant2code
RUN useradd -u 1000 -ms /bin/bash -g plant2code plant2code
COPY . /var/www/plant2code
COPY --chown=plant2code:plant2code . /var/www/plant2code
USER plant2code

EXPOSE 9000

ENTRYPOINT []


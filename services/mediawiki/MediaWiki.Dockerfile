FROM mediawiki:1.43

WORKDIR /var/www/html

# Install necessary system packages and PHP extensions for PostgreSQL and ZIP
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    libzip-dev \
    libpq-dev \
    wget \
    vim \
 && docker-php-ext-install zip pdo_pgsql pgsql \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer

# Copy composer file and install dependencies
COPY composer.local.json .
RUN composer self-update 2.1.3 && composer update --no-dev

# Copy application files and set correct ownership
COPY --chown=www-data:www-data . .

# Optional if not using `--chown` in COPY
# RUN chown -R www-data:www-data /var/www/html

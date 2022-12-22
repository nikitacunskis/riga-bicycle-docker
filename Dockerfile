FROM php:8.0-fpm-alpine

# Install system dependencies
RUN apk update && apk add --no-cache \
    autoconf \
    build-base \
    libtool \
    nginx \
    supervisor \
    git \
    curl \
    curl-dev \
    oniguruma-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    tokenizer \
    ctype \
    json \
    bcmath \
    curl

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add application user
RUN addgroup -S app && adduser -S -G app app

# Set working directory
WORKDIR /var/www/html

# Pull code from Git repository
RUN git clone https://github.com/USERNAME/REPO.git .

# Change ownership of application files
RUN chown -R app:app /var/www/html

# Run composer
RUN composer install --optimize-autoloader --no-dev

# Generate application key
RUN php artisan key:generate

# Expose port 9000 and 80
EXPOSE 9000 80

# Run PHP-FPM and nginx
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

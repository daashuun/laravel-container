FROM webdevops/php-nginx:8.1-alpine

# Install Laravel framework system requirements (https://laravel.com/docs/8.x/deployment#optimizing-configuration-loading)
RUN apk add oniguruma-dev postgresql-dev libxml2-dev && \
    docker-php-ext-install bcmath ctype fileinfo mbstring pdo_pgsql xml

# Copy Composer binary from the Composer official Docker image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY src/nginx.conf /etc/nginx/conf.d/app.conf
COPY src/schedule-command.sh /usr/bin/laravel-schedule
COPY src/queue-command.sh /usr/bin/laravel-queue
COPY src/supervisord.conf /opt/docker/etc/supervisor.d/workers.conf

ENV WEB_DOCUMENT_ROOT /app/public

WORKDIR /app

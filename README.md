# Image for Laravel 8.x-9.x app

Image launching laravel application in docker
container with working queues and schedules

## Running development environment
- start project
```
cd /path/to/project
docker run --rm -d \
 -v $(pwd):/app \
 --name laravel-app \
 daashuun/laravel:1.0-alpine
```
- restart queue worker
```
docker exec -it laravel-app sh -c "supervisorctl restart queue:queued"
```
- restart schedule worker
```
docker exec -it laravel-app sh -c "supervisorctl restart schedule:scheduled"
```

## Running production environment
- start project
```
cd /path/to/project
docker run --rm \
 -v $(pwd):/app \
 --name laravel-app \
 --env APP_ENV=production \
 daashuun/laravel:1.0-alpine
```

## Custom configurations
- nginx
```
docker run --rm \
 -v $(pwd):/app \
 -v /path/to/conf:/etc/nginx/conf.d/app.conf \
 --name laravel-app \
 daashuun/laravel:1.0-alpine
```
- supervisor
```
docker run --rm \
 -v $(pwd):/app \
 -v /path/to/conf:/opt/docker/etc/supervisor.d/program.conf \
 --name laravel-app \
 daashuun/laravel:1.0-alpine
```
## Override worker commands

### Commands
```
#!/bin/sh
php /app/artisan queue:listen
```
```
#!/bin/sh
php /app/artisan schedule:work
```
### Overriding
```
docker run --rm \
 -v $(pwd):/app \
 -v /path/to/queue/script:/usr/bin/laravel-queue \
 -v /path/to/schedule/script:/usr/bin/laravel-schedule \
 --name laravel-app \
 daashuun/laravel:1.0-alpine
```
## Using in compose
```
version: '3'
services:
  app:
    container_name: laravel-app
    image: daashuun/laravel:1.0-alpine
    extra_hosts:
      - 'host.docker.internal:host-gateway'
    ports:
      - '${APP_PORT:-8080}:80'
    volumes:
      - './:/app'
      - './prod/nginx.conf:/etc/nginx/conf.d/app.conf'
      - './prod/atd.conf:/opt/docker/etc/supervisor.d/atd.conf'
```

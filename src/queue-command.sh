#!/bin/sh
php /app/artisan queue:work --max-time=3600

#!/bin/bash
until mysqladmin ping
do 
echo waiting for paroisse-db
sleep 2
done

sudo -u www-data cv --cwd=/app api job.execute
sudo -u www-data drush --no-interaction --quiet --root /app core:cron
pkill mysqlrouter

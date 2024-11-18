#!/bin/ash -e

echo ""
echo "Starting PePaNDI"

if [ "$(stat -c %F /var/www/html)" != "symbolic link" ]; then
  echo "Copying Panel files to /pelican-data/"
  rm /var/www/html/.env

  for file in /var/www/html/* /var/www/html/.*; do
    if [ "$file" != "/var/www/html/." ] && [ "$file" != "/var/www/html/.." ]; then
      cp -rdn "$file" "/pelican-data/"
    fi
  done

  rm -rf /var/www/html
  ln -s /pelican-data/ /var/www/html
fi

if [ -f /pelican-data/.env ]; then
  echo "/pelican-data/.env - file detected"

else
  echo "/pelican-data/.env - file not detected"
  touch /pelican-data/.env
  
  echo -e "Generating APP_KEY"
  APP_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo -e "Generated APP_KEY: $APP_KEY"
  
  echo -e "APP_2FA_REQUIRED=\"0\"" >> /pelican-data/.env
  echo -e "APP_ACTIVITY_HIDE_ADMIN=\"false\"" >> /pelican-data/.env
  echo -e "APP_ACTIVITY_PRUNE_DAYS=\"90\"" >> /pelican-data/.env
  echo -e "APP_API_APPLICATION_RATELIMIT=\"240\"" >> /pelican-data/.env
  echo -e "APP_API_CLIENT_RATELIMIT=\"720\"" >> /pelican-data/.env
  echo -e "APP_BACKUP_DRIVER=\"wings\"" >> /pelican-data/.env
  echo -e "APP_DEBUG=\"true\"" >> /pelican-data/.env
  echo -e "APP_ENV=\"production\"" >> /pelican-data/.env
  echo -e "APP_ENVIRONMENT_ONLY=\"false\"" >> /pelican-data/.env
  echo -e "APP_FAVICON=\"/pelican.ico\"" >> /pelican-data/.env
  echo -e "APP_INSTALLED=\"false\"" >> /pelican-data/.env
  echo -e "APP_KEY=$APP_KEY" >> /pelican-data/.env
  echo -e "APP_LOCALE=\"en\"" >> /pelican-data/.env
  echo -e "APP_NAME=\"Pelican\"" >> /pelican-data/.env
  echo -e "APP_TIMEZONE=\"UTC\"" >> /pelican-data/.env
  echo -e "APP_URL=\"http://localhost\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "BACKUP_THROTTLE_LIMIT=\"2\"" >> /pelican-data/.env
  echo -e "BACKUP_THROTTLE_PERIOD=\"600\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "CACHE_STORE=\"file\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "DB_CONNECTION=\"mariadb\"" >> /pelican-data/.env
  echo -e "DB_DATABASE=\"pelican\"" >> /pelican-data/.env
  echo -e "DB_HOST=\"\"" >> /pelican-data/.env
  echo -e "DB_PASSWORD=\"\"" >> /pelican-data/.env
  echo -e "DB_PORT=\"3306\"" >> /pelican-data/.env
  echo -e "DB_USERNAME=\"pelican\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "FILAMENT_TOP_NAVIGATION=\"false\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "GUZZLE_CONNECT_TIMEOUT=\"5\"" >> /pelican-data/.env
  echo -e "GUZZLE_TIMEOUT=\"15\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "LOG_CHANNEL=\"daily\"" >> /pelican-data/.env
  echo -e "LOG_DEPRECATIONS_CHANNEL=\"null\"" >> /pelican-data/.env
  echo -e "LOG_LEVEL=\"debug\"" >> /pelican-data/.env
  echo -e "LOG_STACK=\"single\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "MAIL_EHLO_DOMAIN=\"\"" >> /pelican-data/.env
  echo -e "MAIL_ENCRYPTION=\"tls\"" >> /pelican-data/.env
  echo -e "MAIL_FROM_ADDRESS=\"pelican@localhost\"" >> /pelican-data/.env
  echo -e "MAIL_FROM_NAME=\"Pelican\"" >> /pelican-data/.env
  echo -e "MAIL_HOST=\"\"" >> /pelican-data/.env
  echo -e "MAIL_MAILER=\"smtp\"" >> /pelican-data/.env
  echo -e "MAIL_PASSWORD=\"\"" >> /pelican-data/.env
  echo -e "MAIL_PORT=\"465\"" >> /pelican-data/.env
  echo -e "MAIL_USERNAME=\"pelican\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "PANEL_CLIENT_ALLOCATIONS_ENABLED=\"true\"" >> /pelican-data/.env
  echo -e "PANEL_SEND_INSTALL_NOTIFICATION=\"true\"" >> /pelican-data/.env
  echo -e "PANEL_SEND_REINSTALL_NOTIFICATION=\"true\"" >> /pelican-data/.env
  echo -e "PANEL_USE_BINARY_PREFIX=\"true\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "QUEUE_CONNECTION=\"database\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "RECAPTCHA_ENABLED=\"false\"" >> /pelican-data/.env
  echo -e "RECAPTCHA_DOMAIN=\"https://www.google.com/recaptcha/api/siteverify\"" >> /pelican-data/.env
  echo -e "RECAPTCHA_SECRET_KEY=\"6LcJcjwUAAAAALOcDJqAEYKTDhwELCkzUkNDQ0J5\"" >> /pelican-data/.env
  echo -e "RECAPTCHA_WEBSITE_KEY=\"6LcJcjwUAAAAAO_Xqjrtj9wWufUpYRnK6BW8lnfn\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "SESSION_DOMAIN=\"null\"" >> /pelican-data/.env
  echo -e "SESSION_DRIVER=\"database\"" >> /pelican-data/.env
  echo -e "SESSION_ENCRYPT=\"true\"" >> /pelican-data/.env
  echo -e "SESSION_PATH=\"/\"" >> /pelican-data/.env
  echo -e "SESSION_SECURE_COOKIE=\"true\"" >> /pelican-data/.env
  echo -e "" >> /pelican-data/.env
  echo -e "TRUSTED_PROXIES=\"\"" >> /pelican-data/.env
fi

cd /var/www/html/

echo -e "Migrating Database"
php artisan migrate --force

echo -e "Optimizing Filament"
php artisan filament:optimize

echo -e "Starting cron jobs"
crond -L /var/log/crond -l 5

echo -e "Updating permissions"
chmod -R 755 /var/www/html/storage
chmod -R 755 /var/www/html/bootstrap/cache
chown -R www-data:www-data /etc/nginx /pelican-data /var/www/html /var/www/html/

echo "Starting Supervisord"
exec "$@"
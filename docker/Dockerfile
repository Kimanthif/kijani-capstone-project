FROM php:8.2-fpm

# Install nginx
RUN apt-get update && apt-get install -y nginx

# Copy app
COPY app/src/ /var/www/html/

# Copy nginx config
COPY nginx.conf /etc/nginx/sites-available/default

# Copy application code (ONLY if it exists inside docker/app/src)
COPY app/src/ /var/www/html/

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["/start.sh"]
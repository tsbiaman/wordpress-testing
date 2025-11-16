# Build a WordPress image that copies the repo files into Apache root
# This image is meant to be small and to maintain all plugins/themes in the image
# for easy deploys. wp-config.php is explicitly not copied so secrets remain out
# of the image.

FROM wordpress:6.5.2-php8.2-apache

# Copy WordPress files (excluding wp-config.php and .git)
COPY --chown=33:33 . /var/www/html/

# Keep wp-config.php off the image - if present, it will be ignored in .dockerignore
RUN rm -f /var/www/html/wp-config.php || true

# Ensure proper permissions for www-data
RUN chown -R www-data:www-data /var/www/html

# Optional: tune PHP settings for production if needed
# COPY php.ini /usr/local/etc/php/

# Expose same port Apache uses
EXPOSE 80

CMD ["apache2-foreground"]

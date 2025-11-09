FROM php:8.2-apache
COPY ./site/ /var/www/html/
WORKDIR /var/www/html

EXPOSE 80

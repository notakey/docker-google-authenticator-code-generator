FROM php:7.1.8-fpm

# docker build -f "Dockerfile" -t "notakey/totp:latest" "./"
# docker run --name totp -p 80:80 notakey/totp:latest


MAINTAINER Ingemars Asmanis "ingemars.asmanis@notakey.com"

EXPOSE 80 

RUN apt-get update  -y
RUN apt-get install -y curl locales supervisor zip unzip nginx libmcrypt-dev mcrypt 
# php  php-fpm php-common php-cli php-curl php-mcrypt php-mbstring

####################
# PHP create needed directories
# RUN service php7.0-fpm start

RUN echo "error_reporting = E_ERROR|E_WARNING|E_PARSE" /usr/local/etc/php/php.ini && \
 echo "display_errors = On" >> /usr/local/etc/php/php.ini && \
 echo "fastcgi.logging = 0" >> /usr/local/etc/php/php.ini && \
 echo "error_log = /run/php/php.log" >> /usr/local/etc/php/php.ini && \
 sed -i -e "s/error_log .*/error_log stderr info;/g" /etc/nginx/nginx.conf  && \
 sed -i -e "s/access_log .*/access_log \/dev\/stdout;/g" /etc/nginx/nginx.conf && \
 mkdir /run/php && \
 mkfifo /run/php/php.log && \
 chown www-data -R /run/php
 
#

####################
# Supervised processes
COPY ./assets/php-fpm-supervisord.conf /etc/supervisor/conf.d/php-fpm.conf
COPY ./assets/nginx-supervisord.conf /etc/supervisor/conf.d/nginx.conf
COPY ./assets/logger-supervisord.conf /etc/supervisor/conf.d/logger.conf


####################
# Nginx config 
COPY ./assets/nginx-site.conf /etc/nginx/sites-available/default

####################
# Startup script 
COPY ./assets/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

####################
# Sets home directory, also needed later in Dockerfile
WORKDIR /var/www/html


COPY ./src  /var/www/html

####################
# Composer
RUN curl -sS https://getcomposer.org/installer | php 
RUN php composer.phar install --no-dev

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
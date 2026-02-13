FROM php:8.2-apache
# Installa le estensioni per connettersi a MySQL
RUN docker-php-ext-install pdo pdo_mysql
# Imposta la cartella di lavoro
WORKDIR /var/www/html
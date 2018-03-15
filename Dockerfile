FROM php:5.6-apache

RUN set -e

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    gettext libcurl4-openssl-dev libpq-dev libmysqlclient-dev libldap2-dev libxslt-dev \
    libxml2-dev libicu-dev libfreetype6-dev libjpeg62-turbo-dev libmemcached-dev \
    zlib1g-dev libpng12-dev unixodbc-dev \
    locales libaio1 libcurl3 libgss3 libicu52 libmysqlclient18 libpq5 libmemcached11 libmemcachedutil2 libldap-2.4-2 libxml2 libxslt1.1 unixodbc libmcrypt-dev git\
     unzip ghostscript locales apt-transport-https
RUN echo 'Generating locales..'
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN echo 'en_AU.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen

RUN echo "Installing php extensions"
RUN docker-php-ext-install -j$(nproc) \
    intl \
    mysqli \
    opcache \
    pgsql \
    soap \
    xsl \
    xmlrpc \
    zip

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install -j$(nproc) ldap

RUN pecl install solr redis igbinary xdebug-2.5.0
RUN docker-php-ext-enable solr redis igbinary xdebug

# Keep our image size down..
RUN pecl clear-cache
RUN apt-get remove --purge -y gettext libcurl4-openssl-dev libpq-dev libmysqlclient-dev libldap2-dev libxslt-dev \
    libxml2-dev libicu-dev libfreetype6-dev libjpeg62-turbo-dev libmemcached-dev \
    zlib1g-dev libpng12-dev unixodbc-dev
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN git clone -b MOODLE_32_STABLE https://github.com/moodle/moodle.git /var/www/html

RUN mkdir /var/www/moodledata && chown www-data /var/www/moodledata && \
    mkdir /var/www/phpunitdata && chown www-data /var/www/phpunitdata && \
    mkdir /var/www/behatdata && chown www-data /var/www/behatdata && \
    mkdir /var/www/behatfaildumps && chown www-data /var/www/behatfaildumps

ADD config.php /var/www/html/config.php


ENV WWWROOT=http://localhost
ENV DBTYPE=mariadb
ENV DBHOST=localhost
ENV DBNAME=moodle
ENV DBUSER=root
ENV DBPASS=123456
ENV DBPORT=3306
ENV DBSOCKET=1
ENV PREFIX=mdl_
ENV LANG=es

CMD ["apache2-foreground"]
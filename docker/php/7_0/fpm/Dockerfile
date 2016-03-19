FROM php:7.0.0-fpm

ENV DEBIAN_FRONTEND noninteractive

# Install iconv mcrypt opcache intl zip gd
RUN apt-get update && apt-get install -y curl unzip openssh-client \
        libfreetype6-dev libpng12-dev libjpeg62-turbo-dev \
        libmcrypt-dev \        
        libicu-dev \
        libsasl2-dev libldap2-dev \
        && ln -fs /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/ \
        && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install bcmath exif iconv intl ldap mbstring mcrypt opcache pdo_mysql zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# Install Xdebug
RUN pecl install xdebug-2.4.0RC2
RUN echo zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so > /usr/local/etc/php/conf.d/xdebug.ini

# Install APCu
RUN pecl install apcu
RUN pecl install apcu_bc-1.0.1
RUN echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apc.ini 
RUN echo "extension=apc.so" >> /usr/local/etc/php/conf.d/apc.ini 

# Configurations
ADD xdebug-add /usr/local/bin/xdebug-add
ADD xdebug-remove /usr/local/bin/xdebug-remove
RUN chmod +x /usr/local/bin/xdebug-add /usr/local/bin/xdebug-remove
ADD php.ini /usr/local/etc/php/php.ini
ADD fpm.ini /usr/local/etc/php-fpm.d/www.conf

RUN echo Europe/Paris | tee /etc/timezone &&  dpkg-reconfigure --frontend noninteractive tzdata
RUN ssh-keygen -N "" -f ~/.ssh/id_rsa && echo "votre clef publique" && cat ~/.ssh/id_rsa.pub

CMD ["php-fpm"]
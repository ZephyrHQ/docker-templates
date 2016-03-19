FROM zephyrdocument_fpm

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y nodejs-legacy npm mysql-client git vim bash-completion
RUN npm install -g bower
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin
RUN mv /usr/local/bin/composer.phar /usr/local/bin/composer

RUN curl https://raw.githubusercontent.com/jaytaph/SFConsole/master/console_completion.sh > /etc/bash_completion.d/symfony2
RUN curl https://raw.githubusercontent.com/qbbr/symfony-bash-completion/master/composer-autocomplete.bash > /etc/bash_completion.d/composer

ADD bash.bashrc /etc/bash.bashrc
ADD .bashrc /root/.bashrc

WORKDIR /var/www/html

ENTRYPOINT []

CMD ["/usr/bin/watch", "ls"]
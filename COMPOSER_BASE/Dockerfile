#Compilation d'une image de base avec php, en utilisant composer de la distribution pour récupérer la dernière version de composer
FROM ubuntu:lunar
LABEL uepal.name="uepal/composer_base" uepal.version="0.1.0"
RUN usermod -L -s /usr/sbin/nologin -e 1 ubuntu
ENV LANG=C.UTF-8
RUN apt-get update && apt-get full-upgrade -y && export DEBIAN_FRONTEND=noninteractive && ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime && apt-get install -y tzdata && dpkg-reconfigure --frontend noninteractive tzdata && apt-get install -y wget php8.1 php8.1-cli php8.1-curl php8.1-gd php8.1-intl php8.1-uploadprogress php8.1-mysql php8.1-opcache php8.1-xml php8.1-bcmath php8.1-mbstring php8.1-soap php8.1-xsl php8.1-zip php8.1-imagick composer libxml2-utils && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists
RUN groupadd -g 1001 -f paroisse && useradd -d /nonexistent -e 1 -g 1001 -u 1001 -M -N -s /usr/sbin/nologin paroisse && usermod -L paroisse
RUN mkdir /app && mkdir /composer
COPY composer.json /composer/composer.json
COPY 99-civiparoisse.ini /etc/php/8.1/cli/conf.d
COPY 99-civiparoisse.ini /etc/php/8.1/apache2/conf.d
RUN chown root:root /etc/php/8.1/apache2/conf.d/99-civiparoisse.ini && chown root:root /etc/php/8.1/cli/conf.d/99-civiparoisse.ini && chmod 444 /etc/php/8.1/cli/conf.d/99-civiparoisse.ini && chmod 444 /etc/php/8.1/apache2/conf.d/99-civiparoisse.ini
ENV COMPOSER_HOME=/tmp
ENV COMPOSER_ALLOW_SUPERUSER=1
WORKDIR /composer
RUN composer install && ln -s /composer/vendor/composer/composer/bin/composer /usr/local/bin/composer
WORKDIR /app
CMD ["composer"]



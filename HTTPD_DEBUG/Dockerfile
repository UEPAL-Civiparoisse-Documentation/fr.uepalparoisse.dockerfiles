#Image du serveur web avec outils de débuggage (pour dev)
FROM uepal_test/httpd
ARG BUILDVERSION=0.0.1
LABEL uepal.name="httpd_debug" uepal.version=${BUILDVERSION}
RUN  apt-get update && apt-get install php8.1-xdebug && rm -rf /var/lib/apt/lists
COPY 99-xdebug.ini /etc/php/8.1/apache2/conf.d/
COPY 99-xdebug.ini /etc/php/8.1/cli/conf.d/

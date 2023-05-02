#Extension de l'image des outils avec xdebug
FROM uepal_test/tools
LABEL uepal.name="tools_debug" uepal.version="0.1.0"
RUN  apt-get update && apt-get install php8.1-xdebug && rm -rf /var/lib/apt/lists
COPY 99-xdebug.ini /etc/php/8.1/apache2/conf.d/
COPY 99-xdebug.ini /etc/php/8.1/cli/conf.d/
CMD ["sh","-c","while true;do sleep 10;done"]

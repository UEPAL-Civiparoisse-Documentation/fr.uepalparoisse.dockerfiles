# Image pour fixer les fichiers statiques qui constitueront le code de base d'une instance de civiparoisse
FROM uepal_test/composer_base
LABEL uepal.name="composer_files" uepal.version="0.1.0"
#ADD composer_registry.tar.gz /
#RUN  chown -R root /composer_registry && mkdir /composer_home
RUN mkdir /composer_home
COPY composer.* /app/
COPY config_date_preferences.php /app/
COPY config_smtp.php /app/
WORKDIR /app
ENV COMPOSER_HOME="/composer_home"
RUN /composer/vendor/bin/composer install -vvv
RUN install -d /app/private && install -d /app/web/sites && chown -R paroisse:www-data /app && find /app -type d -exec chmod 550 '{}' \; && find /app -type f -exec chmod 440 '{}' \; && chmod 770 /app/web/sites && chmod 770 /app/private


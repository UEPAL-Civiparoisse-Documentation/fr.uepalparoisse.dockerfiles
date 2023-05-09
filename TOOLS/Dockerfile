#Image avec les outils pour l'exploitation
FROM uepal_test/composer_base
ARG BUILDVERSION=0.0.1
LABEL uepal.name="tools" uepal.version=${BUILDVERSION}
#ARG MYSQLVERSION=8.0.28-0ubuntu4
#ENV MYSQLVERSIONENV=${MYSQLVERSION}
#RUN echo "MySQLVERSION : "${MYSQLVERSION}
ENV DBSECRET="dbsecret" DBROOTSECRET="dbrootsecret" DRUPAL_ADMIN_USER_SECRET="drupal_user" DRUPAL_ADMIN_PASSWORD_SECRET="drupal_password"
RUN mkdir /tools && mkdir /exec && touch /usr/share/man/man5/maildir.maildrop.5.gz && touch /usr/share/man/man7/maildirquota.maildrop.7.gz && touch /usr/share/man/man1/makedat.1.gz && apt-get update && apt-get full-upgrade -y && export DEBIAN_FRONTEND=noninteractive && apt-get install -y gnupg mysql-client sudo nano openssh-client mc mysql-server maildrop rsync lftp openssh-client dnsutils && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists
COPY exec.sh /exec/exec.sh
COPY config_mysqld.cnf /etc/mysql/mysql.conf.d/
WORKDIR /tools
COPY --from=uepal_test/composer_files /app /app/
RUN chmod 550 /app/vendor/bin/* && ln -s /app/vendor/bin/drush /usr/local/bin/drush && wget https://download.civicrm.org/cv/cv.phar -O /usr/local/bin/cv && chmod 755 /usr/local/bin/cv && chmod 755 /exec/exec.sh && maildirmake /maildir && install -d /var/run/secrets && chmod 555 /etc/mysql/mysql.conf.d/config_mysqld.cnf
COPY secrets /var/run/secrets/
RUN chown -R root:root /var/run/secrets && find /var/run/secrets -type f -exec chmod 400 '{}' \; && find /var/run/secrets -type d -exec chmod 500 '{}' \;
WORKDIR /app
VOLUME /var/lib/mysql /app/web/sites /maildir /app/private
CMD ["/exec/exec.sh"]


#Image d'initialisation d'une instance civiparoisse
FROM uepal_test/tools
ARG BUILDVERSION=0.0.1
LABEL uepal.name="init" uepal.version=${BUILDVERSION}
ENV PAROISSE_NAME="Paroisse Uepal de test" PAROISSE_ADDR="1b,quai Saint Thomas" PAROISSE_CITY="Strasbourg"  PAROISSE_PHONE="0011223344" PAROISSE_ZIPCODE="67000" CIVI_DOMAIN="DomaineParoisse" DBNAME_CIVICRM="civicrm" DBNAME_DRUPAL="drupal" DBNAME_CIVILOG="civilog" DBHOST="localhost" DBUSER="exploitant" DBSECRET="dbsecret" DBROOTSECRET="dbrootsecret" DRUPAL_ADMIN_USER_SECRET="drupal_user" DRUPAL_ADMIN_PASSWORD_SECRET="drupal_password" SERVERNAME="civicrm.test" TRUSTED_HOST_PATTERNS="['^civicrm\\.test$']" MAILADMIN_ADDR="imapusername@civicrm.test" MAILADMIN_NAME="Admin ADMIN" MAILADMIN_DESCR="mail admin descr" MAILDIR="/maildir" SITENAME="Site de test civicrm" IMAP_USERNAME_SECRET="imapUsername" IMAP_PASSWORD_SECRET="imapPassword" MAILDOMAIN="civicrm.test" BOUNCE_LOCALPART="civibounce+" BOUNCE_RETURNPATH="bounce@civicrm.test" IMAP_SERVER="imap" IMAP_PORT="993" IMAP_IS_SSL="1" IMAP_INBOX_FOLDER="INBOX" SMTP_USERNAME_SECRET="smtpUsername" SMTP_PASSWORD_SECRET="smtpPassword" SMTP_HOST="smtp" SMTP_PORT="25" MAILSITE_ADDR="imapusername@civicrm.test" MAILDOMAIN_ADDR="imapusername@civicrm.test" PAROISSE_STREETNUMBER="1"
RUN rsync -av /app/web/sites/ /sites_orig && rsync -av /var/lib/mysql/ /mysql_orig && rm -Rf /app/web/sites/* && rm -Rf /var/lib/mysql/*
COPY exec.sh /exec/exec.sh
RUN chown -R root:root /exec && chmod -R 500 /exec

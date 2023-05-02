#!/bin/bash
set -xev
#get secrets 
DRUPAL_ADMIN_USER=`cat /var/run/secrets/${DRUPAL_ADMIN_USER_SECRET}`
DRUPAL_ADMIN_PASSWORD=`cat /var/run/secrets/${DRUPAL_ADMIN_PASSWORD_SECRET}`
DBPASSWD=`cat /var/run/secrets/${DBSECRET}`
DBROOTPASSWD=`cat /var/run/secrets/${DBROOTSECRET}`
IMAP_USERNAME=`cat /var/run/secrets/${IMAP_USERNAME_SECRET}`
IMAP_PASSWORD=`cat /var/run/secrets/${IMAP_PASSWORD_SECRET}`
export CIVICRM_SETTINGS=/app/web/sites/default/civicrm.settings.php



exit_if_initialized()
{
    if [[ ! ((-n `find /var/lib/mysql -maxdepth 0 -type d -empty `) && ( -n `find /app/web/sites -maxdepth 0 -type d -empty` )) ]]
    then
	echo "Already initialized"
	exit 0;	
    fi
}


close_database()
{
#pkill -3 mysql
#service mysql stop
echo "$DBROOTPASSWD"|mysqladmin --host=localhost --user=root -p shutdown
}
initialize_database()
{
#echo "skip_networking = 1" >>/etc/mysql/mysql.conf.d/mysqld.cnf #présent dans le fichier de conf rajouté
mysqld --initialize-insecure --user=mysql
service mysql restart
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql
mysqladmin --host=localhost --user=root shutdown
service mysql restart
(cat <<EOF
create database ${DBNAME_CIVICRM};
create database ${DBNAME_DRUPAL};
create database ${DBNAME_CIVILOG};
create user ${DBUSER}@'%' identified by '${DBPASSWD}';
grant all on ${DBNAME_CIVICRM}.* to ${DBUSER}@'%';
grant all on ${DBNAME_DRUPAL}.* to ${DBUSER}@'%';
grant all on ${DBNAME_CIVILOG}.* to ${DBUSER}@'%';
GRANT
  SELECT,
  INSERT,
  UPDATE,
  DELETE,
  CREATE,
  DROP,
  INDEX,
  ALTER,
  CREATE TEMPORARY TABLES,
  LOCK TABLES,
  TRIGGER,
  CREATE ROUTINE,
  ALTER ROUTINE,
  REFERENCES,
  CREATE VIEW,
  SHOW VIEW
ON ${DBNAME_CIVICRM}.* to ${DBUSER}@'%';
alter user 'root'@'localhost'  identified with 'caching_sha2_password' by '${DBROOTPASSWD}';
flush privileges;
EOF
)|mysql
}
initialize_drupal()
{
rsync -av /sites_orig/ /app/web/sites 
drush --no-interaction --root /app si  --db-url=mysql://${DBUSER}:${DBPASSWD}@localhost/${DBNAME_DRUPAL} --site-name="${SITENAME}" standard --account-pass="${DRUPAL_ADMIN_PASSWORD}" --account-name="${DRUPAL_ADMIN_USER}" --locale=fr --account-mail="${MAILADMIN_ADDR}" --site-mail="${MAILSITE_ADDR}"
}
initialize_civicrm()
{
    cv core:install --cwd=/app --plugin-path="/app/vendor/uepal/fr.uepalparoisse.civisetup" --db="mysql://${DBUSER}:${DBPASSWD}@localhost/${DBNAME_CIVICRM}" --cms-base-url="https://${SERVERNAME}"  -vvv --src-path /app/vendor/civicrm/civicrm-core
}
    #config drupal
configure_drupal()
{

    echo "\$settings['trusted_host_patterns']=${TRUSTED_HOST_PATTERNS};" >>/app/web/sites/default/settings.php
#    echo "\$settings['trusted_host_patterns'][]='^intern$';" >>/app/web/sites/default/settings.php
    echo "\$config['locale.settings']['translation']['use_source'] = 'local';" >>/app/web/sites/default/settings.php
echo "\$settings['reverse_proxy']=TRUE;" >>/app/web/sites/default/settings.php
echo "\$settings['reverse_proxy_addresses']=[\$_SERVER['REMOTE_ADDR']];" >>/app/web/sites/default/settings.php
echo "\$settings['reverse_proxy_trusted_headers'] = \Symfony\Component\HttpFoundation\Request::HEADER_X_FORWARDED_FOR | \Symfony\Component\HttpFoundation\Request::HEADER_X_FORWARDED_HOST| \Symfony\Component\HttpFoundation\Request::HEADER_X_FORWARDED_PROTO | \Symfony\Component\HttpFoundation\Request::HEADER_X_FORWARDED_PORT;" >>/app/web/sites/default/settings.php

    
#    drush --no-interaction --root /app config:set system.site mail "${MAILADMIN_ADDR}"
#    drush --no-interaction --root /app theme:enable seven
#    drush --no-interaction --root /app config-set system.theme default seven
    drush --no-interaction --root /app theme:enable claro
    drush --no-interaction --root /app config-set system.theme default claro
    drush --no-interaction --root /app -n pm:enable content_translation config_translation locale language
    drush --no-interaction --root /app config:set -n system.site default_langcode fr
    drush --no-interaction --root /app config:set -n system.site langcode fr
#    drush --no-interaction --root /app pm:enable uepal_druparoisse
}    
#config civicrm
configure_civicrm()
{
    sed -i "2i define('CIVICRM_MAIL_SMARTY',1); " /app/web/sites/default/civicrm.settings.php
    chmod 400 /app/web/sites/default/civicrm.settings.php
    drush --no-interaction --root /app config:set system.site page.403 /user/login
    drush --no-interaction --root /app config:set system.site page.front /civicrm
#    cv --cwd=/app api mailSettings.create id=1 domain="${MAILDOMAIN}" protocol=2 localpart="bouncehandling+" source="${MAILDIR}" is_default="1" name="maildir_default"
    cv --cwd=/app api Setting.create enableSSL=1
    cv --cwd=/app api email.create id=1 email="${MAILDOMAIN_ADDR}"
    cv --cwd=/app api address.create contact_id=1 location_type_id=Domicile street_address="${PAROISSE_ADDR}" street_number="${PAROISSE_STREETNUMBER}" city="${PAROISSE_CITY}" postal_code="${PAROISSE_ZIPCODE}" country_id="FR" is_primary=1
    cv --cwd=/app api phone.create  phone="${PAROISSE_PHONE}" contact_id=1 is_primary=1
    CIVICRM_VERSION=`cv --cwd=/app api domain.getvalue return="version" id=1 sequential=1|tr -d '"'`
    cv --cwd=/app api contact.create id=1 display_name="${PAROISSE_NAME}" sort_name="${PAROISSE_NAME}" legal_name="${PAROISSE_NAME}" organization_name="${PAROISSE_NAME}" contact_type="Organization" location_type_id="1" email_id="1"
#    cv --cwd=/app api domain.create id=1 name="${CIVI_DOMAIN}" domain_email="${SERVERNAME}" contact_id=1 domain_version="${CIVICRM_VERSION}" email_id=1
    cv --cwd=/app api domain.create id=1 name="${CIVI_DOMAIN}" contact_id=1 domain_version="${CIVICRM_VERSION}" email_id=1
    echo "{
\"option_group_id\":\"from_email_address\", \"api.OptionValue.create\":{\"name\":\"${MAILADMIN_NAME} <${MAILADMIN_ADDR}>\" ,\"label\":\"${MAILADMIN_NAME} <${MAILADMIN_ADDR}>\",\"description\":\"${MAILADMIN_DESCR}\"}}"|cv --cwd=/app api OptionValue.get --in=json
    cv --cwd=/app api setting.create lcMessages="fr_FR"
    cv --cwd=/app/web php:script /app/config_date_preferences.php
    cv --cwd=/app/web php:script /app/config_smtp.php
    cv --cwd=/app api mailSettings.create id=1 domain_id=1 domain="${MAILDOMAIN}" protocol=1 localpart="${BOUNCE_LOCALPART}" return_path="${BOUNCE_RETURNPATH}" is_default="1" name="bounce_default" server="${IMAP_SERVER}" port=${IMAP_PORT} username="${IMAP_USERNAME}" password="${IMAP_PASSWORD}" is_ssl=${IMAP_IS_SSL} source=${IMAP_INBOX_FOLDER} is_non_case_email_skipped=0 is_contact_creation_disabled_if_no_match=0

#    cv --cwd=/app ev 'Civi::settings()->set("authx_guards",["perm"]);'
#    cv --cwd=/app ev 'Civi::settings()->set("authx_param_cred",[]);'
#    cv --cwd=/app ev 'Civi::settings()->set("authx_param_user","require");'
#    cv --cwd=/app ev 'Civi::settings()->set("authx_header_cred",["pass"]);'
#    cv --cwd=/app ev 'Civi::settings()->set("authx_header_user","require");'
#    cv --cwd=/app ev 'Civi::settings()->set("authx_xheader_cred",[]);'
#    cv --cwd=/app ev 'Civi::settings()->set("authx_xheader_user","require");'
#    cv --cwd=/app ev 'Civi::settings()->set("authx_login_cred",[]);'
#    cv --cwd=/app ev 'Civi::settings()->set("authx_login_user","require");'
#    cv --cwd=/app ev 'Civi::settings()->set("authx_auto_cred",[]);'
#    cv --cwd=/app ev 'Civi::settings()->set("authx_auto_user","require");'

    for i in geocoder org.civicrm.recentmenu search_kit uk.co.vedaconsulting.mosaico afform_admin fr.uepalparoisse.civiparoisse #si proxy : aussi authx
    do
       cv --cwd=/app ext:enable ${i}
    done;

    cv --cwd=/app  api setting.create geoProvider="Geocoder"
    cv --cwd=/app  api setting.create mapProvider="OpenStreetMaps"
    cv --cwd=/app  api setting.create maxFileSize=3
    drush --no-interaction --root /app config:import --partial --source=/app/vendor/uepal/fr.uepalparoisse.civiroles -vvv

}
#cache_rebuild
cache_rebuild()
{
    drush --no-interaction --root /app cr
    cv --cwd=/app api system.flush
    drush --no-interaction --root /app cr
    cv --cwd=/app api system.flush
}
configure_civicrm_logging()
{
    sed -i "2i define('CIVICRM_LOGGING_DSN','mysql://${DBUSER}:${DBPASSWD}@localhost/${DBNAME_CIVILOG}'); " /app/web/sites/default/civicrm.settings.php
    cv --cwd=/app api setting.create logging=1
    cv --cwd=/app api system.updatelogtables
}
configure_file_rights()
{
    #only for files in file volume (not db volume, not container)
    chown -R paroisse:www-data /app/web/sites
    chown -R paroisse:www-data /app/private
    find /app/web/sites/ -type d -exec chmod 770 '{}' \;
    find /app/web/sites/ -type f -exec chmod 660 '{}' \;
    find /app/web/sites/ -type f -name .htaccess -exec chmod 440 '{}' \;
    find /app/private -type d -exec chmod 770 '{}' \;
    find /app/private -type f -exec chmod 660 '{}' \;
    chmod 750 /app/web/sites/default
    chmod 640 /app/web/sites/default/settings.php
    chmod 440 /app/web/sites/default/civicrm.settings.php

}

    exit_if_initialized
    initialize_database
    initialize_drupal
    initialize_civicrm
    configure_drupal
    configure_civicrm
    configure_civicrm_logging
    cache_rebuild
    configure_file_rights
    close_database

    DRUPAL_ADMIN_USER=""
    DRUPAL_ADMIN_PASSWORD=""
    DBPASSWD=""
    DBROOTPASSWD=""
    

#!/bin/bash
set -xev
DRUPAL_ADMIN_USER=`cat /var/run/secrets/${DRUPAL_ADMIN_USER_SECRET}`
DRUPAL_ADMIN_PASSWORD=`cat /var/run/secrets/${DRUPAL_ADMIN_PASSWORD_SECRET}`
DBPASSWD=`cat /var/run/secrets/${DBSECRET}`
DBROOTPASSWD=`cat /var/run/secrets/${DBROOTSECRET}`

export CIVICRM_SETTINGS=/app/web/sites/default/civicrm.settings.php
reconfigure_mysql_datadir_owner()
{
chown -R mysql /var/lib/mysql
}
start_database()
{
service mysql start
}
cache_rebuild()
{
    drush --no-interaction --root /app cr
    cv --cwd=/app api system.flush
    drush --no-interaction --root /app cr
    cv --cwd=/app api system.flush
}

close_database()
{
#pkill -3 mysql
#service mysql stop
#mysqladmin shutdown
echo "$DBROOTPASSWD"|mysqladmin --host=localhost --user=root -p shutdown
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


upgrade_drupal()
{
    drush -l https://${SERVERNAME} --no-interaction --root /app updatedb
    TRANSLATION_FILE=`find /app/web/sites/default/files/translations -name "*.po"|head -1`
    echo "TRANSLATION_FILE : ${TRANSLATION_FILE}"
    if [[ -n "${TRANSLATION_FILE}" ]]
    then 
        drush -l https://${SERVERNAME} --no-interaction --root /app locale:import --override=not-customized --type=not-customized fr ${TRANSLATION_FILE}
    else
        echo "TRANSLATION_FILE NOT FOUND"
    fi
}
upgrade_civicrm()
{
    cv --no-interaction --cwd=/app upgrade:db
}
upgrade_civicrm_ext()
{
    cv --no-interaction --cwd=/app ext:upgrade-db
    drush -l https://${SERVERNAME} --no-interaction --root /app config:import --partial --source=/app/vendor/uepal/fr.uepalparoisse.civiroles -vvv
}
echo "SERVERNAME : ${SERVERNAME}"
reconfigure_mysql_datadir_owner
start_database
cache_rebuild
upgrade_drupal
cache_rebuild
upgrade_civicrm
cache_rebuild
upgrade_civicrm_ext
cache_rebuild
close_database
configure_file_rights

 DRUPAL_ADMIN_USER=""
 DRUPAL_ADMIN_PASSWORD=""
 DBPASSWD=""
 DBROOTPASSWD=""

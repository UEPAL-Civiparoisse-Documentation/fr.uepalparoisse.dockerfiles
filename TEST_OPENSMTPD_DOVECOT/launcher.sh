#!/bin/bash
export SMTP_USER=`cat /var/run/secrets/${SMTP_USER_SECRET}`
export SMTP_PASSWD=`cat /var/run/secrets/${SMTP_PASSWD_SECRET}`
export IMAP_PASSWD=`cat /var/run/secrets/${IMAP_PASSWD_SECRET}`
export IMAP_USER1=`cat /var/run/secrets/${IMAP_USER_SECRET}`
export IMAP_USER2=`cat /var/run/secrets/${IMAP_USER2_SECRET}`
exec supervisord -c /etc/supervisor/supervisord.conf -n

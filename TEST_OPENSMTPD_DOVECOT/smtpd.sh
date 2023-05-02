#!/bin/bash
set -xev
echo -e "${SMTP_USER}\t`smtpctl encrypt ${SMTP_PASSWD}`" >/KEYS/smtp_passwd
echo -e "@\tvmail" >/KEYS/vusers
#echo -e "${IMAP_USER1}@test.test\t${IMAP_USER1}" >/KEYS/vusers
#echo -e "${IMAP_USER2}@test.test\t${IMAP_USER2}" >/KEYS/vusers
echo -e "${IMAP_USER1}" >/KEYS/users
echo -e "${IMAP_USER2}" >>/KEYS/users

exec /usr/sbin/smtpd -d -f /etc/smtpd_standalone.conf -v

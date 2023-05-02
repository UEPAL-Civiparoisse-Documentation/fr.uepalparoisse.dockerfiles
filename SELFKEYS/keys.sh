#!/bin/bash
set -xev
rm -Rf USAGE
rm -Rf CA
# 2 CA :
# externe : pour l'affichage dehors (browser : civicrm.test) ;
#  DB SSL
for i in extern_ca civicrmdb db_ca mail_ca wildcard_ca
do
    openssl genrsa -out ${i}.pem 2048
    openssl req -new -key ${i}.pem -out ${i}.req -subj "/C=FR/ST=France/L=Strasbourg/O=TEST/OU=INFRA/CN=${i}"
done
openssl genrsa -out extern.pem 2048
openssl req -new -key extern.pem -out extern.req -subj "/C=FR/ST=France/L=Strasbourg/O=TEST/OU=INFRA/CN=civicrm.test"

openssl genrsa -out wildcard.pem 2048
openssl req -new -key wildcard.pem -out wildcard.req -subj "/C=FR/ST=France/L=Strasbourg/O=TEST/OU=INFRA/CN=*.test"

cat >mail.ext <<EOF
[ext]
subjectAltName=DNS:localhost,IP:127.0.0.1,DNS:imap,DNS:smtp,DNS:imapdemo,DNS:smtpdemo
EOF


openssl genrsa -out mail.pem 2048
openssl req -new -key mail.pem -out mail.req -subj "/C=FR/ST=France/L=Strasbourg/O=TEST/OU=INFRA/CN=civimail"

cat >extern.ext <<EOF
[ext]
subjectAltName=DNS:civicrm.test
EOF

cat >wildcard.ext <<EOF
[ext]
subjectAltName=DNS:*.test
EOF



for i in db_ca extern_ca mail_ca wildcard_ca
do
  openssl x509 -req -in ${i}.req -out ${i}.x509 -days 3650 -signkey ${i}.pem
done
openssl x509 -req -in extern.req -out extern.x509 -days 3649 -CA extern_ca.x509 -CAkey extern_ca.pem -CAserial extern_ca.srl -CAcreateserial -extfile extern.ext -extensions ext
openssl x509 -req -in wildcard.req -out wildcard.x509 -days 3649 -CA wildcard_ca.x509 -CAkey wildcard_ca.pem -CAserial wildcard_ca.srl -CAcreateserial -extfile wildcard.ext -extensions ext
openssl x509 -req -in civicrmdb.req -out civicrmdb.x509 -days 3649 -CA db_ca.x509 -CAkey db_ca.pem -CAserial db_ca.srl -CAcreateserial
openssl x509 -req -in mail.req -out mail.x509 -days 3649 -CA mail_ca.x509 -CAkey mail_ca.pem -CAserial mail_ca.srl -CAcreateserial -extfile mail.ext -extensions ext
install -d CA
install -d USAGE
cp db_ca.x509 USAGE
cp extern_ca.x509 USAGE
cp wildcard_ca.x509 USAGE
cp mail_ca.x509 USAGE
mv db_ca.* CA
mv extern_ca.* CA
mv wildcard_ca.* CA
mv mail_ca.* CA
for i in pem x509 req ext
do
mv *.${i} USAGE
done
chmod 400 USAGE/*
chmod 400 CA/*

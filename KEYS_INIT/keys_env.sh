#!/bin/bash
set -ex
rm -Rf /KEYS/USAGE
rm -Rf /KEYS/CA
rm -Rf /CERTS/*
#generation des clefs pour le certificat présenté à l'extérieur : nom SERVERNAME
openssl genrsa -out extern.pem 2048
openssl req -new -key extern.pem -out extern.req -subj "/C=FR/ST=France/L=Strasbourg/O=TEST/OU=INFRA/CN=${SERVERNAME}"

#generation des clefs pour le serveur de mail
openssl genrsa -out mail.pem 2048
openssl req -new -key mail.pem -out mail.req -subj "/C=FR/ST=France/L=Strasbourg/O=TEST/OU=INFRA/CN=${MAILHOST}"

#generation des clefs pour le wildcard de traefik
openssl genrsa -out wildcard.pem 2048
openssl req -new -key wildcard.pem -out wildcard.req -subj "/C=FR/ST=France/L=Strasbourg/O=TEST/OU=INFRA/CN=${WILDCARDNAME}"

#generation des clefs pour ce qui peut avoir un nom générique
for i in extern_ca civicrmdb db_ca mail_ca wildcard_ca
do
    openssl genrsa -out ${i}.pem 2048
    openssl req -new -key ${i}.pem -out ${i}.req -subj "/C=FR/ST=France/L=Strasbourg/O=TEST/OU=INFRA/CN=${i}"
done
#fichier d'extension pour le serveur de mail
cat >mail.ext <<EOF
[ext]
subjectAltName=DNS:localhost,IP:127.0.0.1,DNS:imap,DNS:smtp,DNS:imapdemo,DNS:smtpdemo,DNS:${MAILHOST}
EOF


#fichier d'extension pour le certificat Apache externe
cat >extern.ext <<EOF
[ext]
subjectAltName=DNS:${SERVERNAME}
EOF

cat >wildcard.ext <<EOF
[ext]
subjectAltName=DNS:${WILDCARDNAME}
EOF

# autosignature des CA
for i in db_ca extern_ca mail_ca wildcard_ca
do
    openssl x509 -req -in ${i}.req -out ${i}.x509 -days 3650 -signkey ${i}.pem
done
#signature des certificats : le premier est toujours particulier, puisqu'il faut initialiser le serial
#signature du certificat pour l'usage externe
openssl x509 -req -in extern.req -out extern.x509 -days 3649 -CA extern_ca.x509 -CAkey extern_ca.pem -CAserial externca.srl -CAcreateserial -extfile extern.ext -extensions ext
#signature du certificat pour le wildcard
openssl x509 -req -in wildcard.req -out wildcard.x509 -days 3649 -CA wildcard_ca.x509 -CAkey wildcard_ca.pem -CAserial wildcard_ca.srl -CAcreateserial -extfile wildcard.ext -extensions ext
#signature des certificats pour la BD
openssl x509 -req -in civicrmdb.req -out civicrmdb.x509 -days 3649 -CA db_ca.x509 -CAkey db_ca.pem -CAserial db_ca.srl -CAcreateserial
#signature du certificat pour le mail
openssl x509 -req -in mail.req -out mail.x509 -days 3649 -CA mail_ca.x509 -CAkey mail_ca.pem -CAserial mail_ca.srl -CAcreateserial -extfile mail.ext -extensions ext



#et on range les fichiers
install -d /KEYS/CA
install -d /KEYS/USAGE
cp mail_ca.x509 /usr/local/share/ca-certificates/mail_ca.crt
cp db_ca.x509 /KEYS/USAGE
cp extern_ca.x509 /KEYS/USAGE
cp wildcard_ca.x509 /KEYS/USAGE
cp mail_ca.x509 /KEYS/USAGE
mv db_ca.* /KEYS/CA
mv extern_ca.* /KEYS/CA
mv wildcard_ca.* /KEYS/CA
mv mail_ca.* /KEYS/CA
for i in pem x509 req ext
do
mv *.${i} /KEYS/USAGE
done
chmod 444 /KEYS/USAGE/*
chmod 400 /KEYS/USAGE/mail.*
chmod 400 /KEYS/CA/*
chown root:root /usr/local/share/ca-certificates/* && chmod 644 /usr/local/share/ca-certificates/*
#on lance le calcul du hash des certificats et on prépare le volume de sortie
update-ca-certificates && cp -RL /etc/ssl/certs/* /CERTS


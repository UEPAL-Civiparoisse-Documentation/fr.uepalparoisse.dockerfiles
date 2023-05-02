#Image pour embarquer des clefs qui ont été prégénéres par le script keys.sh depuis l'ĥôte
FROM ubuntu:lunar
LABEL uepal.name="keys" uepal.version="0.1.0"
RUN usermod -L -s /usr/sbin/nologin -e 1 ubuntu
ENV LANG=C.UTF-8
RUN mkdir /KEYS && mkdir /KEYS/USAGE && chmod -R 500 /KEYS && apt-get update && apt-get full-upgrade -y && apt-get install -y ca-certificates && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists && install -d /target_certs
COPY USAGE/* /KEYS/USAGE/
#COPY USAGE/db_ca.x509 /usr/local/share/ca-certificates/db_ca.crt
#COPY USAGE/extern_ca.x509 /usr/local/share/ca-certificates/extern_ca.crt
COPY USAGE/mail_ca.x509 /usr/local/share/ca-certificates/mail_ca.crt
RUN chown root:root /usr/local/share/ca-certificates/* && chmod 644 /usr/local/share/ca-certificates/*
RUN update-ca-certificates && cp -RL /etc/ssl/certs /dereferenced_certs
WORKDIR /KEYS
CMD ["/bin/bash","-c","cp -LR /dereferenced_certs/* /target_certs/"]
#CMD ["/bin/bash","-c", "echo 'Hello KEYS'"]


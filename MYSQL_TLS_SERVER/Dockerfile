#Image du serveur BD
FROM ubuntu/mysql:latest
LABEL uepal.name="uepal_test/mysql_tls_server" uepal.version="0.1.0"
ENV LANG=C.UTF-8
RUN apt-get update && apt-get full-upgrade -y && export DEBIAN_FRONTEND=noninteractive && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists
RUN mkdir /KEYS
COPY --from=uepal_test/selfkeys KEYS/USAGE/civicrmdb.* /KEYS/
COPY --from=uepal_test/selfkeys KEYS/USAGE/db_ca.x509 /KEYS/
COPY config_mysqld.cnf /etc/mysql/conf.d/
RUN chgrp -R mysql /KEYS && chmod 440 /KEYS/* && chmod 550 /KEYS && chown mysql:mysql /etc/mysql/conf.d/config_mysqld.cnf && chmod 440 /etc/mysql/conf.d/config_mysqld.cnf



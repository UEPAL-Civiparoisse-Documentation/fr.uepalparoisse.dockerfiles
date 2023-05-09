#Image pour la génération des clefs nécessaires au déploiement d'une instance (surtout pour les devs avec Docker)
FROM ubuntu:lunar
ARG BUILDVERSION=0.0.1
LABEL uepal.name="keys_init" uepal.version=${BUILDVERSION}
RUN usermod -L -s /usr/sbin/nologin -e 1 ubuntu
ENV LANG=C.UTF-8
ENV SERVERNAME=civicrm.test WILDCARDNAME=*.test MAILHOST=civimail.test
RUN  apt-get update && apt-get full-upgrade -y && apt-get install -y openssl ca-certificates && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists && mkdir /CERTS
COPY keys_env.sh /
WORKDIR /KEYS
VOLUME /KEYS
VOLUME /CERTS
CMD ["/keys_env.sh"]


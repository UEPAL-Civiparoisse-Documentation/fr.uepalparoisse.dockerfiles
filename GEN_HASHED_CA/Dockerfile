#Image pour regénérer les CA (utile pour intégration d'une CA privée, surtout pour les devs)
FROM ubuntu:lunar
ARG BUILDVERSION=0.0.1
LABEL uepal.name="hashedCA" uepal.version=${BUILDVERSION}
RUN usermod -L -s /usr/sbin/nologin -e 1 ubuntu
ENV LANG=C.UTF-8
RUN mkdir /CERTS && export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get full-upgrade -y && apt-get install -y ca-certificates && apt-get remove --purge --autoremove -y && rm -rf /var/lib/apt/lists
VOLUME /usr/local/share/ca-certificates
VOLUME /CERTS
CMD ["/bin/bash","-c","update-ca-certificates && cp -RL /etc/ssl/certs/* /CERTS/"]

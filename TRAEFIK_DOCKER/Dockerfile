#Image faisant office d'ingress controller pour simuler (dans une certaine mesure) sous Docker ce qu'on met dans K8S via helm
FROM traefik
ARG BUILDVERSION=0.0.1
LABEL uepal.name="traefik_docker" uepal.version=${BUILDVERSION}
ENV SERVERNAME=civicrm.test
RUN mkdir /CA && mkdir /etc/traefik && mkdir /etc/traefik/conf.d && mkdir /KEYS
COPY --from=uepal_test/selfkeys /KEYS/USAGE/extern_ca.x509 /CA/extern_ca.x509
COPY --from=uepal_test/selfkeys /KEYS/USAGE/wildcard.x509 /KEYS/wildcard.x509
COPY --from=uepal_test/selfkeys /KEYS/USAGE/wildcard.pem /KEYS/wildcard.pem
COPY traefik.yml /etc/traefik/traefik.yml
COPY traefik_dynamic.yml /etc/traefik/conf.d/traefik_dynamic.yml
RUN chown root:root -R /KEYS /CA /etc/traefik && chmod 500 /KEYS /CA /etc/traefik /etc/traefik/conf.d && chmod 400 /CA/* /etc/traefik/traefik.yml /etc/traefik/conf.d/* /KEYS/*
CMD ["traefik","--configfile=/etc/traefik/traefik.yml"]


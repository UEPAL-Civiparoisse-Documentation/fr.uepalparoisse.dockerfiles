#Image pour disposer de mysqlrouter pour la connexion chiffrée vers la BD et le montage socket depuis un container du même pod
FROM ubuntu:lunar
ARG BUILDVERSION=0.0.1
LABEL uepal.name="uepal/mysql_tls_router" uepal.version=${BUILDVERSION}
RUN usermod -L -s /usr/sbin/nologin -e 1 ubuntu
ENV LANG=C.UTF-8
RUN mkdir /KEYS && mkdir /etc/mysqlrouter && mkdir /SOCK
RUN apt-get update && apt-get full-upgrade -y && export DEBIAN_FRONTEND=noninteractive && ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime && apt-get install -y tzdata && dpkg-reconfigure --frontend noninteractive tzdata && apt-get install -y mysql-router && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists
COPY --from=uepal_test/selfkeys /KEYS/USAGE/db_ca.x509 /KEYS/
COPY mysqlrouter.conf /etc/mysqlrouter/
COPY exec.sh /
RUN chown root:root /etc/mysqlrouter/mysqlrouter.conf && chown root:root /exec.sh && chmod 444 /etc/mysqlrouter/mysqlrouter.conf && chmod 500 /exec.sh
CMD ["/bin/sh","-c","/exec.sh"]



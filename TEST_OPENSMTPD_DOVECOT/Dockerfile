#Image pour disposer d'un petit environnement avec smtp et imap
#Attention : il faut rester sur ubuntu:focal car il y a un bug dans la version embarquée dans les Ubuntu supérieures.
#Attention : NE PAS INSTALLER EN PROD
FROM ubuntu:focal
ARG BUILDVERSION=0.0.1
LABEL uepal.name="uepal/test_msmtp_dovecot" uepal.version=${BUILDVERSION}
ENV LANG=C.UTF-8
ENV SMTP_USER_SECRET=smtpUsername SMTP_PASSWD_SECRET=smtpPassword IMAP_PASSWD_SECRET=imapPassword IMAP_USER_SECRET=imapUsername IMAP_USER2_SECRET=imapUsername2
RUN apt-get update && apt-get full-upgrade -y && export DEBIAN_FRONTEND=noninteractive && ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime && apt-get install -y tzdata && dpkg-reconfigure --frontend noninteractive tzdata
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y git build-essential wget curl mc nano less telnet autoconf automake libtool-bin gettext texinfo libgnutls28-dev gnutls-bin pkg-config net-tools tcpdump mutt opensmtpd
RUN install -d /var/run/secrets
COPY secrets /var/run/secrets
#RUN git clone https://git.marlam.de/git/msmtp.git /MSMTP
#RUN cd /MSMTP && autoreconf -i && ./configure && make && make install
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y supervisor supervisor-doc dovecot-core dovecot-imapd 
RUN mkdir /MUTT && mkdir /KEYS
#ADD server.key /KEYS
#ADD server.crt /KEYS
COPY --from=uepal_test/selfkeys /KEYS/USAGE/mail.x509 /KEYS/server.crt
COPY --from=uepal_test/selfkeys /KEYS/USAGE/mail.pem /KEYS/server.key
# RUN export DEBIAN_FRONTEND=noninteractive && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists
RUN  groupadd -g 1000 vmail && useradd -u 1000 -g 1000 vmail -d /var/vmail && passwd -l vmail && chown vmail:vmail /var/mail && chown root:vmail /usr/lib/dovecot/dovecot-lda && chmod u+s /usr/lib/dovecot/dovecot-lda && chmod g+x /usr/lib/dovecot/dovecot-lda && chmod o-rwx /usr/lib/dovecot/dovecot-lda && chmod 400 /KEYS/server.key
ADD smtpd_standalone.conf /etc/smtpd_standalone.conf
ADD standalone.conf /etc/dovecot/standalone.conf
ADD supervisor_opensmtpd.conf /etc/supervisor/conf.d/supervisor_opensmtpd.conf
ADD supervisor_dovecot.conf /etc/supervisor/conf.d/supervisor_dovecot.conf
ADD mutt* /MUTT/
ADD smtpd.sh /
ADD launcher.sh /
#CMD ["supervisord","-c","/etc/supervisor/supervisord.conf","-n"]
CMD ["/launcher.sh"]
#CMD ["bash"]

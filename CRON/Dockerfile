#Image pour l'exécution d'un tâche cron
FROM uepal_test/tools
ARG BUILDVERSION=0.0.1
LABEL uepal.name="cron" uepal.version=${BUILDVERSION}
COPY exec.sh /exec/exec.sh
RUN chown -R root:root /exec && chmod -R 500 /exec

#Image pour l'exécution d'un tâche cron
FROM uepal_test/tools
LABEL uepal.name="cron" uepal.version="0.1.0"
COPY exec.sh /exec/exec.sh
RUN chown -R root:root /exec && chmod -R 500 /exec

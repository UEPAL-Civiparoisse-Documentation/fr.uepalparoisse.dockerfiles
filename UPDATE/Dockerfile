#Image pour la mise à jour des parties dynamiques (BD, fichiers dans les volumes) - utile surtout après recompilisation des fichiers statiques d'une isntance Civiparoisse
FROM uepal_test/tools
ARG BUILDVERSION=0.0.1
LABEL uepal.name="update" uepal.version=${BUILDVERSION}
ENV DBHOST="localhost" SERVERNAME="civicrm.test"
COPY update.sh /exec/exec.sh
RUN chown -R root:root /exec && chmod -R 500 /exec

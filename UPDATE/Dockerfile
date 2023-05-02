#Image pour la mise à jour des parties dynamiques (BD, fichiers dans les volumes) - utile surtout après recompilisation des fichiers statiques d'une isntance Civiparoisse
FROM uepal_test/tools
LABEL uepal.name="update" uepal.version="0.1.0"
ENV DBHOST="localhost" SERVERNAME="civicrm.test"
COPY update.sh /exec/exec.sh
RUN chown -R root:root /exec && chmod -R 500 /exec

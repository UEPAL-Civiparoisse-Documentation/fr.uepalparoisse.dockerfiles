#!/bin/bash
set -xev
export EXPBUILDVERSION=`cat VERSION`
echo ${EXPBUILDVERSION}
docker build --rm --no-cache -t uepal_test/selfkeys:${EXPBUILDVERSION} -t uepal_test/selfkeys --build-arg BUILDVERSION=${EXPBUILDVERSION} SELFKEYS 
docker build --rm --no-cache -t uepal_test/keys_init:${EXPBUILDVERSION} -t uepal_test/keys_init --build-arg BUILDVERSION=${EXPBUILDVERSION} KEYS_INIT
docker build --rm --no-cache -t uepal_test/mysql_tls_router:${EXPBUILDVERSION} -t uepal_test/mysql_tls_router --build-arg BUILDVERSION=${EXPBUILDVERSION} MYSQL_TLS_ROUTER
docker build --rm --no-cache -t uepal_test/mysql_tls_server:${EXPBUILDVERSION} -t uepal_test/mysql_tls_server --build-arg BUILDVERSION=${EXPBUILDVERSION} MYSQL_TLS_SERVER
docker build --rm --no-cache -t uepal_test/composer_base:${EXPBUILDVERSION} -t uepal_test/composer_base --build-arg BUILDVERSION=${EXPBUILDVERSION} COMPOSER_BASE
docker build --rm --no-cache -t uepal_test/composer_files:${EXPBUILDVERSION} -t uepal_test/composer_files --build-arg BUILDVERSION=${EXPBUILDVERSION} COMPOSER_FILES
docker build --rm --no-cache -t uepal_test/tools:${EXPBUILDVERSION} -t uepal_test/tools --build-arg BUILDVERSION=${EXPBUILDVERSION} TOOLS
docker build --rm --no-cache -t uepal_test/tools_debug:${EXPBUILDVERSION} -t uepal_test/tools_debug --build-arg BUILDVERSION=${EXPBUILDVERSION} TOOLS_DEBUG
docker build --rm --no-cache -t uepal_test/init:${EXPBUILDVERSION} -t uepal_test/init --build-arg BUILDVERSION=${EXPBUILDVERSION} INIT
docker build --rm --no-cache -t uepal_test/cron:${EXPBUILDVERSION} -t uepal_test/cron --build-arg BUILDVERSION=${EXPBUILDVERSION} CRON
docker build --rm --no-cache -t uepal_test/httpd:${EXPBUILDVERSION} -t uepal_test/httpd --build-arg BUILDVERSION=${EXPBUILDVERSION} HTTPD
docker build --rm --no-cache -t uepal_test/httpd_debug:${EXPBUILDVERSION} -t uepal_test/httpd_debug --build-arg BUILDVERSION=${EXPBUILDVERSION} HTTPD_DEBUG
docker build --rm --no-cache -t uepal_test/update:${EXPBUILDVERSION} -t uepal_test/update --build-arg BUILDVERSION=${EXPBUILDVERSION} UPDATE
docker build --rm --no-cache -t uepal_test/test_opensmtpd_dovecot:${EXPBUILDVERSION} -t uepal_test/test_opensmtpd_dovecot --build-arg BUILDVERSION=${EXPBUILDVERSION} TEST_OPENSMTPD_DOVECOT
docker build --rm --no-cache -t uepal_test/gen_hashed_ca:${EXPBUILDVERSION} -t uepal_test/gen_hashed_ca --build-arg BUILDVERSION=${EXPBUILDVERSION} GEN_HASHED_CA
docker build --rm --no-cache -t uepal_test/traefik_docker:${EXPBUILDVERSION} -t uepal_test/traefik_docker --build-arg BUILDVERSION=${EXPBUILDVERSION} TRAEFIK_DOCKER

#!/bin/bash
set -xev
docker build --rm --no-cache -t uepal_test/selfkeys SELFKEYS
docker build --rm --no-cache -t uepal_test/keys_init KEYS_INIT
docker build --rm --no-cache -t uepal_test/mysql_tls_router MYSQL_TLS_ROUTER
docker build --rm --no-cache -t uepal_test/mysql_tls_server MYSQL_TLS_SERVER
docker build --rm --no-cache -t uepal_test/composer_base COMPOSER_BASE
docker build --rm --no-cache -t uepal_test/composer_files COMPOSER_FILES
docker build --rm --no-cache -t uepal_test/tools TOOLS
docker build --rm --no-cache -t uepal_test/tools_debug TOOLS_DEBUG
docker build --rm --no-cache -t uepal_test/init INIT
docker build --rm --no-cache -t uepal_test/cron CRON
docker build --rm --no-cache -t uepal_test/httpd HTTPD
docker build --rm --no-cache -t uepal_test/httpd_debug HTTPD_DEBUG
docker build --rm --no-cache -t uepal_test/update UPDATE
docker build --rm --no-cache -t uepal_test/test_opensmtpd_dovecot TEST_OPENSMTPD_DOVECOT
docker build --rm --no-cache -t uepal_test/gen_hashed_ca GEN_HASHED_CA
docker build --rm --no-cache -t uepal_test/traefik_docker TRAEFIK_DOCKER

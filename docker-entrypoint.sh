#!/bin/sh
# docker entrypoint script
# configures and starts LDAP

pid=0

# Reduce maximum number of number of open file descriptors to 1024
# otherwise slapd consumes two orders of magnitude more of RAM
# see https://github.com/docker/docker/issues/8231
ulimit -n 1024

# SIGTERM-handler
term_handler() {
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill ${!}; term_handler' SIGTERM

SLAPD_CONF_DIR="/etc/openldap/slapd.d"

chown -R ldap:ldap /var/lib/openldap/openldap-data
chmod -R 750 /var/lib/openldap/openldap-data

slapd -h "ldap:///" -F ${SLAPD_CONF_DIR} -u ldap -g ldap > /stdout.txt 2> /stderr.txt


while [ ! -e /run/slapd/slapd.pid ]; do sleep 0.1; done
pid="$(cat /run/openldap/slapd.pid)"

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
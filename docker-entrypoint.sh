#!/bin/bash
# docker entrypoint script
# configures and starts LDAP

pid=0

# Reduce maximum number of number of open file descriptors to 1024
# otherwise slapd consumes two orders of magnitude more of RAM
# see https://github.com/docker/docker/issues/8231
ulimit -n 1024

# SIGTERM-handler
term_handler() {
  pid=$(cat /var/run/slapd/slapd.pid)
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill ${!}; term_handler' SIGTERM

for f in $(find /base -mindepth 1 -maxdepth 1 -type f | sort); do
  log-helper debug "source file $f"
  source "$f"
done
for f in $(find /custom/env -mindepth 1 -maxdepth 1 -type f -name \*.sh | sort); do
  log-helper debug "source file $f"
  source "$f"
done

if [ -e "$init_done" ] ; then
  log-helper debug "init is already done"
else
  log-helper debug "initialize"

  # Add openldap user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
  # If explicit uid or gid is given, use it.
  addgroup -g ${LDAP_OPENLDAP_GID} ldap && \
  adduser --disabled-password -G ldap -u ${LDAP_OPENLDAP_UID} ldap

  init_settings_db
  create_folder_structure
  init_backend_db
  touch $init_done
fi



# ------------------------old

slapd -h "ldap:///" -F $CONFIG_PATH -u ldap -g ldap -d 256 >> /dev/stdout 2>&1

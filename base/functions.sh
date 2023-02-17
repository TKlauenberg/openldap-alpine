#!/bin/bash

init_settings_db() {
  log-helper debug "init_settings_db"
  log-helper info "Create config db"
  set -e
  set -o pipefail

  get_ldap_base_dn

  log-helper debug "base dn = $BASE_DN"
  # TODO read passwords with files?
  export ADMIN_PASS_ENC="$(slappasswd -s ${ADMIN_PASS})"
  export CONFIG_PASS_ENC="$(slappasswd -s ${CONFIG_PASS})"
  cat /base/settings/00-base.ldif | envsubst > /tmp/slapd.ldif
  log-helper debug "configpath = ${CONFIG_PATH}"
  mkdir -p $CONFIG_PATH
  mkdir -p $DB_PATH
  slapadd -n 0 -F $CONFIG_PATH -l /tmp/slapd.ldif
}

create_folder_structure() {
  log-helper info "Create folder structure and fix rights"
  mkdir /var/run/slapd/
  chown -R ldap:ldap /var/run/slapd/
  chmod -R 750 /var/run/slapd

  mkdir /var/lib/openldap/run
  touch /var/lib/openldap/run/ldapi
  chown ldap:ldap /var/lib/openldap/run/ldapi
  chmod 666 /var/lib/openldap/run/ldapi

  chown -R ldap:ldap $CONFIG_PATH
  chmod -R 750 $CONFIG_PATH
  chown -R ldap:ldap $DB_PATH
  chmod -R 750 $DB_PATH

  mkdir -p $state_folder
}

init_backend_db() {
  log-helper debug "init_backend_db"
  silent slapd -h "ldapi:///" -F $CONFIG_PATH -u ldap -g ldap -d 256 &
  sleep 2.0
  log-helper debug "Waiting for OpenLDAP to be ready"
  until ldapsearch -Y EXTERNAL -Q -H ldapi:/// -s base \& > /dev/null ; do sleep 1.0; done

  for f in $(find /custom/ldif -mindepth 1 -maxdepth 1 -type f -name \*.ldif | sort); do
    log-helper debug "Bootstrap LDIF: Processing file ${f}"
    ldap_add_or_modify "$f"
  done

  slapd_pid=$(cat /var/run/slapd/slapd.pid)
  kill -15 $slapd_pid
}

function get_ldap_base_dn() {
  if [ -z "$BASE_DN" ]; then
    IFS='.' read -ra BASE_DN_TABLE <<< "${DOMAIN}"
    for i in "${BASE_DN_TABLE[@]}"; do
      EXT="dc=$i,"
      BASE_DN=$BASE_DN$EXT
    done

    IFS='.' read -a domain_elems <<< "${DOMAIN}"
    SUFFIX=""
    ROOT=""

    for elem in "${domain_elems[@]}" ; do
        if [ "x${SUFFIX}" = x ] ; then
            SUFFIX="dc=${elem}"
            ROOT="${elem}"
        fi
    done

    export BASE_DN=${BASE_DN::-1}
  fi
}

# base functions
silent() {
    ## Quiet down output
    if [ $CONTAINER_LOG_LEVEL -ge 4 ] ;  then
        "$@"
    else
        "$@" > /dev/null 2>&1
    fi
}

function ldap_add_or_modify() {
  local ldif_file=$1
  cat $ldif_file | envsubst > /tmp/data.ldif
  if grep -iq changetype $ldif_file; then
    silent ldapmodify -Y EXTERNAL -Q -H ldapi:/// -f /tmp/data.ldif
  else
    silent ldapadd -Y EXTERNAL -Q -H ldapi:/// -f /tmp/data.ldif
  fi
}
# #!/command/with-contenv bash

export LDAP_OPENLDAP_UID=${LDAP_OPENLDAP_UID:-"911"}
export LDAP_OPENLDAP_GID=${LDAP_OPENLDAP_GID:-"911"}

# export ADD_DEFAULT_DATA=${ADD_DEFAULT_DATA:-"TRUE"}
export ADMIN_PASS=${ADMIN_PASS:-"admin"}
export CONFIG_PASS=${CONFIG_PASS:-"config"}
export CONFIG_PATH=${CONFIG_PATH:-"/var/lib/openldap/slap.d"}
# export BACKUP_TYPE=${BACKUP_TYPE:-"FILESYSTEM"}
# export BACKUP_COMPRESSION=${BACKUP_COMPRESSION:-GZ}
# export BACKUP_COMPRESSION_LEVEL=${BACKUP_COMPRESSION_LEVEL:-"3"}
# export BACKUP_BEGIN=${BACKUP_BEGIN:-0400}
# export BACKUP_RETENTION=${BACKUP_RETENTION:-"10080"}
# export BACKUP_INTERVAL=${BACKUP_INTERVAL:-1440}
# export BACKUP_PATH=${BACKUP_PATH:-/data/backup}
# export BACKUP_MD5=${BACKUP_MD5:-TRUE}
# export BACKUP_PARALLEL_COMPRESSION=${BACKUP_PARALLEL_COMPRESSION:-TRUE}
# export BACKUP_SIZE_VALUE=${BACKUP_SIZE_VALUE:-"bytes"}
# export BACKUP_TEMP_LOCATION=${BACKUP_TEMP_LOCATION:-"/tmp/backups"}
export DB_PATH=${DB_PATH:-"/var/openldap/data/"}
export DOMAIN=${DOMAIN:-"example.org"}
# export ENABLE_BACKUP=${ENABLE_BACKUP:-"TRUE"}
# export ENABLE_MONITOR=${ENABLE_MONITOR:-"TRUE"}
# export ENABLE_PPOLICY=${ENABLE_PPOLICY:-"TRUE"}
# export ENABLE_READONLY_USER=${ENABLE_READONLY_USER:-"FALSE"}
# export ENABLE_REPLICATION=${ENABLE_REPLICATION:-"FALSE"}
# export ENABLE_TLS=${ENABLE_TLS:-"TRUE"}
export LOG_LEVEL=${LOG_LEVEL:-256}
# export LOG_TYPE=${LOG_TYPE:-"CONSOLE"}
# export LOG_PATH=${LOG_PATH:-"/logs/"}
# export LOG_FILE=${LOG_FILE:-"openldap.log"}
# export ORGANIZATION=${ORGANIZATION:-"Example Organization"}
# export PPOLICY_CHECK_RDN=${PPOLICY_CHECK_RDN:-0}
# export PPOLICY_MAX_CONSEC=${PPOLICY_MAX_CONSEC:-0}
# export PPOLICY_MAX_LENGTH=${PPOLICY_MAX_LENGTH:-0}
# export PPOLICY_MIN_DIGIT=${PPOLICY_MIN_DIGIT:-0}
# export PPOLICY_MIN_LOWER=${PPOLICY_MIN_LOWER:-0}
# export PPOLICY_MIN_POINTS=${PPOLICY_MIN_POINTS:-3}
# export PPOLICY_MIN_PUNCT=${PPOLICY_MIN_PUNCT:-0}
# export PPOLICY_MIN_UPPER=${PPOLICY_MIN_UPPER:-0}
# export PPOLICY_USE_CRACKLIB=${PPOLICY_USE_CRACKLIB:-1}
# export READONLY_USER_PASS=${READONLY_USER_PASS:-"readonly"}
# export READONLY_USER_USER=${READONLY_USER_USER:-"readonly"}
# export REPLICATION_SAFETY_CHECK=${REPLICATION_SAFETY_CHECK:-"TRUE"}
# export SCHEMA_TYPE=${SCHEMA_TYPE:-"nis"}
# export SLAPD_ARGS=${SLAPD_ARGS:-""}
# export SLAPD_HOSTS=${SLAPD_HOSTS:-"ldap://$HOSTNAME ldaps://$HOSTNAME ldapi:///"}
# export TLS_CA_NAME=${TLS_CA_NAME:-"ldap-selfsigned-ca"}
# export TLS_CA_SUBJECT=${TLS_CA_SUBJECT:-"/C=XX/ST=LDAP/L=LDAP/O=LDAP/CN="}
# export TLS_CA_CRT_SUBJECT=${TLS_CA_CRT_SUBJECT:-"${TLS_CA_SUBJECT}${TLS_CA_NAME}"}
# export TLS_CA_CRT_FILENAME=${TLS_CA_CRT_FILENAME:-"${TLS_CA_NAME}.crt"}
# export TLS_CA_KEY_FILENAME=${TLS_CA_KEY_FILENAME:-"${TLS_CA_NAME}.key"}
# export TLS_CA_CRT_PATH=${TLS_CA_CRT_PATH:-"/certs/${TLS_CA_NAME}/"}
# export TLS_CIPHER_SUITE=${TLS_CIPHER_SUITE:-"ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:-DHE-DSS:-RSA:!aNULL:!MD5:!DSS:!SHA"}
# export TLS_CREATE_CA=${TLS_CREATE_CA:-"TRUE"}
# export TLS_CRT_FILENAME=${TLS_CRT_FILENAME:-"cert.pem"}
# export TLS_CRT_PATH=${TLS_CRT_PATH:-"/certs/"}
# export TLS_DH_PARAM_FILENAME=${TLS_DH_PARAM_FILENAME:-"dhparam.pem"}
# export TLS_DH_PARAM_KEYSIZE=${TLS_DH_PARAM_KEYSIZE:-2048}
# export TLS_DH_PARAM_PATH=${TLS_DH_PARAM_PATH:-"/certs/"}
# export TLS_ENFORCE=${TLS_ENFORCE:-"FALSE"}
# export TLS_KEY_FILENAME=${TLS_KEY_FILENAME:-"key.pem"}
# export TLS_KEY_PATH=${TLS_KEY_PATH:-"/certs/"}
# export TLS_RESET_PERMISSIONS=${TLS_RESET_PERMISSIONS:-"TRUE"}
# export TLS_VERIFY_CLIENT=${TLS_VERIFY_CLIENT:-"try"}
export ULIMIT_N=${ULIMIT_N:-"1024"}
# export WAIT_FOR_REPLICAS=${WAIT_FOR_REPLICAS:-"FALSE"}
export state_folder="/var/lib/openldap/state/"
export init_done="${state_folder}slapd-first-start-done"
export was_started_with_replication="${state_folder}docker-openldap-was-started-with-replication"
export was_started_with_tls="${state_folder}docker-openldap-was-started-with-tls"
export was_started_with_tls_enforce="${state_folder}docker-openldap-was-started-with-tls-enforce"

container=$(buildah from alpine:latest)
LDAP_OPENLDAP_GID=911
LDAP_OPENLDAP_UID=911

buildah run $container -- addgroup -g ${LDAP_OPENLDAP_GID} ldap && \
  adduser --disabled-password -G ldap -u ${LDAP_OPENLDAP_UID} ldap

buildah run $container -- apk add --update openldap openldap-back-mdb openldap-clients openldap-overlay-memberof openldap-overlay-dynlist

mountpoint=$(buildah mount $container)

rm -rf ${mountpoint}/var/cache/apk/*

cp ./docker-entrypoint.sh ${mountpoint}/
chmod 774 ${mountpoint}/docker-entrypoint.sh

cp ./slapd.conf ${mountpoint}/etc/openldap/slapd.conf
rm -rf ${mountpoint}/etc/openldap/slapd.d
mkdir ${mountpoint}/etc/openldap/slapd.d

chown -R ${LDAP_OPENLDAP_UID}:${LDAP_OPENLDAP_GID} /run/openldap

buildah run $container -- slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d


chown -R ${LDAP_OPENLDAP_UID}:${LDAP_OPENLDAP_GID} ${mountpoint}/etc/openldap/slapd.d
chown -R ${LDAP_OPENLDAP_UID}:${LDAP_OPENLDAP_GID} ${mountpoint}/var/lib/openldap/openldap-data
chmod -R 750 ${mountpoint}/var/lib/openldap/openldap-data

buildah config --volume "/etc/openldap/slapd.d" \
  --volume "/var/lib/openldap/openldap-data" \
  --volume "/container"


buildah config --env LOG_LEVEL=stats \
  --env CONTAINER_LOG_LEVEL=5 \
  --volume "/etc/openldap/slapd.d" \
  --volume "/var/lib/openldap/openldap-data" \
  --volume "/container" \
  --port 389 \
  --port 636 \
  --entrypoint /docker-entrypoint.sh \
  --cmd /docker-entrypoint.sh \
  $container

buildah commit $container buildah-openldap
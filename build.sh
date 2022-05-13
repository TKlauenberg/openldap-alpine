container=$(buildah from alpine:latest)
LDAP_OPENLDAP_GID=911
LDAP_OPENLDAP_UID=911

buildah run $container -- addgroup -g ${LDAP_OPENLDAP_GID} ldap && \
  adduser --disabled-password -G ldap -u ${LDAP_OPENLDAP_UID} ldap

buildah config --env LOG_LEVEL=stats \
  --env CONTAINER_LOG_LEVEL=5 \
  --port 389 \
  --port 636 \
  $container

buildah run $container -- apk add --update openldap openldap-back-mdb openldap-clients openldap-overlay-memberof openldap-overlay-dynlist && \
  rm -rf /var/cache/apk/*

buildah copy $container ./docker-entrypoint.sh /
buildah copy $container slapd.conf /etc/openldap/slapd.conf

buildah run $container -- chmod 774 docker-entrypoint.sh && \
  rm -rf /etc/openldap/slapd.d && \
  mkdir /etc/openldap/slapd.d && \
  mkdir /run/openldap && \
  chown -R ldap:ldap /run/openldap && \
  slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d && \
  chown -R ldap:ldap /etc/openldap/slapd.d && \
  chown -R ldap:ldap /var/lib/openldap/openldap-data && \
  chmod -R 750 /var/lib/openldap/openldap-data

buildah copy $container ./app /container

buildah config --volume "/etc/openldap/slapd.d" \
  --volume "/var/lib/openldap/openldap-data" \
  --volume "/container"

buildah config --entrypoint /docker-entrypoint.sh $container
buildah config --cmd /docker-entrypoint.sh $container

buildah commit $container buildah-openldap
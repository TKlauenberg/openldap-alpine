FROM alpine:latest

ARG LDAP_OPENLDAP_GID=911
ARG LDAP_OPENLDAP_UID=911

# Add openldap user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# If explicit uid or gid is given, use it.
RUN  addgroup -g ${LDAP_OPENLDAP_GID} ldap && \
  adduser --disabled-password -G ldap -u ${LDAP_OPENLDAP_UID} ldap

ENV LOG_LEVEL=stats \
  CONTAINER_LOG_LEVEL=5

EXPOSE 389
EXPOSE 636

RUN apk add --update openldap openldap-back-mdb openldap-clients openldap-overlay-memberof openldap-overlay-dynlist && \
  rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /
COPY slapd.conf /etc/openldap/slapd.conf

RUN chmod 774 docker-entrypoint.sh && \
  rm -rf /etc/openldap/slapd.d && \
  mkdir /etc/openldap/slapd.d && \
  mkdir /run/openldap && \
  chown -R ldap:ldap /run/openldap && \
  slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d && \
  chown -R ldap:ldap /etc/openldap/slapd.d && \
  chown -R ldap:ldap /var/lib/openldap/openldap-data && \
  chmod -R 750 /var/lib/openldap/openldap-data

VOLUME ["/etc/openldap/slapd.d", "/var/lib/openldap/openldap-data"]

ENTRYPOINT /docker-entrypoint.sh
CMD /docker-entrypoint.sh

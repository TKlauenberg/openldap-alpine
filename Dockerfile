FROM alpine:latest

ARG LDAP_OPENLDAP_GID=911
ARG LDAP_OPENLDAP_UID=911

# Add openldap user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# If explicit uid or gid is given, use it.
RUN  addgroup -g ${LDAP_OPENLDAP_GID} ldap && \
  adduser --disabled-password -G ldap -u ${LDAP_OPENLDAP_UID} ldap

ARG S6_OVERLAY_VERSION

### Set defaults
ENV S6_OVERLAY_VERSION=${S6_OVERLAY_VERSION:-"3.1.2.1"}

EXPOSE 389
EXPOSE 636

RUN apk add --update bash curl gettext openldap openldap-back-mdb openldap-clients openldap-overlay-memberof openldap-overlay-dynlist && \
  rm -rf /var/cache/apk/*

### S6 overlay installation
RUN apkArch="$(apk --print-arch)"  && \
  case "$apkArch" in \
  x86_64) s6Arch='x86_64' ;; \
  armv7) s6Arch='armhf' ;; \
  armhf) s6Arch='armhf' ;; \
  aarch64) s6Arch='aarch64' ;; \
  *) echo >&2 "Error: unsupported architecture ($apkArch)"; exit 1 ;; \
  esac; \
  curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar xpfJ - -C / && \
  curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${s6Arch}.tar.xz | tar xpfJ - -C / && \
  curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz | tar xpfJ - -C /


COPY tools/* /sbin/
COPY s6-overlay /etc/s6-overlay
RUN chmod -R 777 /etc/s6-overlay/scripts

COPY openldap /var/openldap

ENTRYPOINT ["/init"]

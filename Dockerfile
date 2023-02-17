FROM alpine:latest

EXPOSE 389
EXPOSE 636

RUN apk add --update bash curl gettext openldap openldap-back-mdb openldap-clients openldap-overlay-memberof openldap-overlay-dynlist && \
  rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
COPY tools/* /sbin/
RUN chmod -R +x /sbin
COPY base /base
COPY custom /custom

ENTRYPOINT /docker-entrypoint.sh
CMD /docker-entrypoint.sh

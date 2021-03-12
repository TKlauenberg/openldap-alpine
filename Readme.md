# openldap-alpine

In this repository i have a minimal configuration for running openldap in alpine. At the moment the resulting container does have only a config database loaded and every other database should first be added.

## future goals
At the moment some parts are not working which I would like to solf in the future.
So a not yet completed list on future goals are:

1. check for better ways to initialize a container
   1. initial data load
   2. backup/restore
2. logging (at the moment the openldap log isn't routed to stdout)
3. support ldaps and not only ldap protocol
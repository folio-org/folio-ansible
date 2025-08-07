# mod-reporting-config

Configure mod-reporting with tenant reporting database configuration.

[mod-reporting](https://github.com/folio-org/mod-reporting) is the successor module to [mod-ldp](https://github.com/folio-org/mod-ldp). It has the same API as mod-ldp, but provides full support for [Metadb](https://github.com/metadb-project/metadb) reporting databases as well as legacy [ldp](https://github.com/library-data-platform/ldp) reporting databases.

Metadb is part of the [Library Data Platform project](https://librarydataplatform.org/) (LDP) of the Open Library Foundation.

## Requirements

Assumes mod-reporting has been deployed and enabled for tenant and that the reporting database has been created and configured.

## Variables/defaults
```yaml
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432

admin_user:
  username: diku_admin
  password: admin

tenant: diku

ldp_user: ldp
ldp_db: ldp
ldp_password: diku_ldp9367

# Enable saved query config. Default is 'false'
enable_saved_query_config: false

# Set the following if 'enable_saved_query_config' is set to true
#gh_owner:
#gh_repo:
#gh_token:
```

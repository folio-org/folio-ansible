# Variables used in Ansible playbooks and roles

These could be overridden with `group_vars` or `host_vars`.

## YAML for variables with default values
```yaml
---
# common role
folio_user: folio
folio_group: folio

# docker-engine role
docker_users:
  - "{{ folio_user }}"
# {{ folio_user }} from common dependency

# maven-3 role
maven_version: 3.3.9

# mod-auth-src role
mod_auth_src_home: /opt/mod-auth-src

# mod-circulation-build role
mod_circulation_src_home: /opt/mod-circulation-src

# mod-circulation-docker role
# also uses {{ mod_circulation_src_home }} from mod-circulation-build dependency

# mod-users-build role
mod_users_src_home: /opt/mod-users-src
# {{ folio_user }} and {{ folio_group }} from common dependency

# mod-users-demo role
mod_users_home: /opt/mod-users
okapi_url: http://localhost:9130/
mod_users_pg_user: mod_users
mod_users_pg_password: mod_users25
mod_users_db: diku
# {{ mod_users_src_home }} from mod-users-build dependency
# {{ folio_user }} and {{ folio_group }} from common dependency

# mod-users-docker role
# also uses {{ mod_users_src_home }} from mod-users-build dependency

# okapi-demo role
okapi_src_home: /opt/okapi-src
okapi_home: /opt/okapi
okapi_pg_user: okapi
okapi_pg_password: okapi25
# {{ folio_user }} and {{ folio_group }} from common dependency

# okapi-docker role
okapi_src_home: /opt/okapi-src
# also uses {{ folio_group }} and {{ folio_user }} from common dependency

# okapi-src role
okapi_src_home: /opt/okapi-src
okapi_home: /opt/okapi

# okapi-test role
# also uses {{ okapi_src_home }} from okapi-src dependency

# raml-module-builder role
raml_module_builder_home: /opt/raml-module-builder

# stripes-core role
stripes_home: /opt/stripes

# tenant-data role
okapi_url: http://localhost:9130/

# ui-users
# also uses {{ stripes_home }} from stripes-core dependency
```

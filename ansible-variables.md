# Variables used in Ansible playbooks and roles

These could be overridden with `group_vars` or `host_vars`.

## YAML for variables with default values
```yaml
---
# demo-data role
okapi_url: http://localhost:9130/

# docker-engine role
docker_users:
  - "{{ ansible_user_id }}"

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

# mod-users-demo role
mod_users_home: /opt/mod-users
okapi_url: http://localhost:9130/
# also uses {{ mod_users_src_home }} from mod-users-build dependency

# mod-users-docker role
# also uses {{ mod_users_src_home }} from mod-users-build dependency

# okapi-demo role
okapi_src_home: /opt/okapi-src
okapi_home: /opt/okapi

# okapi-docker role
okapi_src_home: /opt/okapi-src

# okapi-src role
okapi_src_home: /opt/okapi-src
okapi_home: /opt/okapi

# okapi-test role
# also uses {{ okapi_src_home }} from okapi-src dependency

# raml-module-builder role
raml_module_builder_home: /opt/raml-module-builder
```


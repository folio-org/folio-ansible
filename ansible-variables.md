# Variables used in Ansible playbooks and roles

These could be overridden with `group_vars` or `host_vars`.

## YAML for variables with default values
```yaml
---
# maven-3 role
maven_version: 3.3.9

# okapi-docker roles
okapi_src_home: /opt/okapi-src

# okapi-src role
okapi_src_home: /opt/okapi-src
okapi_home: /opt/okapi

# okapi-test role
# also uses {{ okapi_src_home }} from okapi-src dependency

# mod-auth-src role
mod_auth_src_home: /opt/mod-auth-src

# raml-module-builder role
raml_module_builder_home: /opt/raml-module-builder

# docker-engine role
docker_users:
  - "{{ ansible_user_id }}"
```

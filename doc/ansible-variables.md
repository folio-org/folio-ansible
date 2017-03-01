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
  - okapi

# maven-3 role
maven_version: 3.3.9

# mod-auth role
# folio_user needs to be a user with access to Docker
folio_user: okapi
mod_auth_home: /usr/share/folio/mod-auth
mod_auth_conf: /etc/folio/mod-auth
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
pg_user: "{{ pg_admin_user }}"
pg_password: "{{ pg_admin_password }}"
mod_auth_db: mod_auth
mod_auth_modules:
  - { index: 0, module: authtoken, docker_image: folioci/mod-authtoken }
  - { index: 1, module: login, docker_image: folioci/mod-login }
  - { index: 2, module: permissions, docker_image: folioci/mod-permissions }
# {{ pg_admin_user }} and {{ pg_admin_password }} from postgresql dependency

# mod-auth-data role
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
mod_auth_modules:
  - { index: 0, module: authtoken-module }
  - { index: 1, module: login-module }
  - { index: 2, module: permissions-module }
mod_auth_admin: { username: diku_admin, password: admin, hash: 52DCA1934B2B32BEA274900A496DF162EC172C1E, salt: 483A7C864569B90C24A0A6151139FF0B95005B16, permissions: "\\\"perms\\\", \\\"login\\\"" }
bootstrap_permissions:
  - { id: 8cd22acd-e347-4382-9344-42020f65bb86, permissionName: login.addUser, subPermissions: "" }
  - { id: e8fd127f-19c6-406a-91b2-fbc601edb0ec, permissionName: login.modifyUser, subPermissions: "" }
  - { id: 71d2aa6a-c39a-4e3c-b7ad-9548a1c8267d, permissionName: login.readUser, subPermissions: "" }
  - { id: 6c7a4410-4ec0-46f5-9fcd-754f47a9e5cd, permissionName: login.removeUser, subPermissions: "" }
  - { id: a239a767-3c49-47c4-99e5-5485dc7ac8fd, permissionName: login, subPermissions: "\\\"login.addUser\\\", \\\"login.modifyUser\\\", \\\"login.removeUser\\\", \\\"login.readUser\\\"" }
  - { id: 83613c13-f412-4bc4-86b6-77e084e39921, permissionName: perms.permissions.create, subPermissions: "" }
  - { id: 5914e7fd-d1d9-455e-b520-f8435a342671, permissionName: perms.permissions.delete, subPermissions: "" }
  - { id: afd0c500-8c01-4140-85d5-11e1461df4d8, permissionName: perms.permissions.read, subPermissions: "" }
  - { id: 4ec6aadd-f5ba-4e32-9c01-d6636261a274, permissionName: perms.permissions, subPermissions: "\\\"perms.permissions.read\\\", \\\"perms.permissions.create\\\", \\\"perms.permissions.delete\\\"" }
  - { id: 9b115c7f-5b2b-4a5f-868f-347362e9e544, permissionName: perms.users.create, subPermissions: "" }
  - { id: dd61cfc2-8a9c-420c-ba74-5400398efa4a, permissionName: perms.users.modify, subPermissions: "" }
  - { id: 5df3f0c6-315f-45ce-a690-f17198c797d9, permissionName: perms.users.delete, subPermissions: "" }
  - { id: 95993363-ee9e-4fad-84db-6c6bba408ef8, permissionName: perms.users.read, subPermissions: "" }
  - { id: 98280690-174f-4251-8138-acea29523e20, permissionName: perms.users, subPermissions: "\\\"perms.users.create\\\", \\\"perms.users.modify\\\", \\\"perms.users.read\\\", \\\"perms.users.delete\\\"" }
  - { id: 250494e9-275f-4b2c-a0b1-8cf65ea0b5ad, permissionName: perms, subPermissions: "\\\"perms.users\\\", \\\"perms.permissions\\\"" }

# mod-auth-demo role
# {{ mod_auth_home }}, {{ folio_user }}, {{ folio_group }},
# {{ okapi_url }}, {{ auth_modules }} from mod-auth dependency

# mod-auth-src role
mod_auth_home: /opt/mod-auth
mod_auth_src_home: /opt/mod-auth-src
okapi_url: http://localhost:9130/
auth_modules:
  - { index: 0, module: login }
  - { index: 1, module: authtoken }
  - { index: 2, module: permissions }
# {{ folio_user }} and {{ folio_group }} from common dependency
# {{ okapi_home }} from okapi-undeploy dependency 


# mod-circulation-build role
mod_circulation_src_home: /opt/mod-circulation-src

# mod-circulation-docker role
# also uses {{ mod_circulation_src_home }} from mod-circulation-build dependency

# mod-metadata role
# folio_user needs to be a user with access to Docker
folio_user: okapi
mod_metadata_home: /usr/share/folio/mod-metadata
mod_metadata_conf: /etc/folio/mod-metadata
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
pg_user: "{{ pg_admin_user }}"
pg_password: "{{ pg_admin_password }}"
mod_metadata_db: mod_metadata
mod_metadata_modules:
  - { index: 0, module: inventory-storage, docker_image: folioci/mod-inventory-storage }
  - { index: 1, module: inventory, docker_image: folioci/mod-inventory }
# {{ pg_admin_user }} and {{ pg_admin_password }} from postgresql dependency

# mod-metadata-build role
mod_metadata_src_home: /opt/mod-metadata-src
# {{ folio_user }} and {{ folio_group }} from common dependency

# mod-metadata-data role
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
mod_metadata_modules:
  - { index: 0, module: inventory-storage }
  - { index: 1, module: inventory }

# mod-metadata-demo role
mod_metadata_home: /opt/mod-metadata
okapi_url: http://localhost:9130/
mod_metadata_pg_user: "{{ pg_admin_user }}" # from postgresql dependency
mod_metadata_pg_password: "{{ pg_admin_password }}" # from postgresql dependency
mod_metadata_db: mod_metadata
# {{ mod_metadata_src_home }} from mod-metadata-build dependency
# {{ folio_user }} and {{ folio_group }} from common dependency
# {{ okapi_home }} from okapi-undeploy dependency 

# mod-users role
# folio_user needs to be a user with access to Docker
folio_user: okapi
mod_users_home: /usr/share/folio/mod-users
mod_users_conf: /etc/folio/mod-users
mod_users_version: 4.0.0-SNAPSHOT
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
pg_user: "{{ pg_admin_user }}"
pg_password: "{{ pg_admin_password }}"
mod_users_db: mod_users
# {{ pg_admin_user }} and {{ pg_admin_password }} from postgresql dependency

# mod-users-build role
mod_users_src_home: /opt/mod-users-src
# {{ folio_user }} and {{ folio_group }} from common dependency

# mod-users-data role
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"

# mod-users-demo role
mod_users_home: /opt/mod-users
okapi_url: http://localhost:9130/
mod_users_pg_user: mod_users
mod_users_pg_password: mod_users25
mod_users_db: mod_users
# {{ mod_users_src_home }} from mod-users-build dependency
# {{ folio_user }} and {{ folio_group }} from common dependency
# {{ okapi_home }} from okapi-undeploy dependency

# mod-users-docker role
# also uses {{ mod_users_src_home }} from mod-users-build dependency

# okapi role
okapi_role: cluster
# 'eth0' is th default ec2 network interface. May be different on other systems
okapi_interface: eth0
okapi_cluster_port: 9001
okapi_cluster_config_file: ""
okapi_port: 9130
okapi_port_start: 9131
okapi_port_end: 9141
# change to 'postgres' for postgres backend
okapi_storage: inmemory
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
okapi_host: "{{ ansible_default_ipv4.address }}"
pg_host: localhost
pg_port: 5432
okapi_pg_user: "{{ pg_admin_user }}" # from postgresql dependency
okapi_pg_password: "{{ pg_admin_password }}" # from postgresql dependency
okapi_pg_database: okapi
okapi_dockerurl: http://localhost:4243

okapi_metrics: 0
carbon_host: localhost
carbon_port: 2003

# Edit the following hazelcast variables as appropriate for your site
# either here or at the host or group var level.  These are mostly
# needed for advanced configuration or running Okapi in 'cluster' mode
# on AWS.
# 
# Set 'hazelcast_aws_conf' to 'true' if 'okapi_role' is 'cluster' and
# you are running on ec2 instances
hazelcast_aws_conf: "false"
hazelcast_aws_region: us-east-1
hazelcast_security_group: okapi
hazelcast_aws_access_key: 12345678
hazelcast_aws_secret_key: 12345678
hazelcast_ec2_tag_key: Group
hazelcast_ec2_tag_value: Demo
hazelcast_address: "10.*"

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

# okapi-undeploy role
okapi_home: /usr/share/folio/okapi
folio_user: okapi
folio_group: okapi

# raml-module-builder role
raml_module_builder_home: /opt/raml-module-builder

# sdkman role
sdkman_user: folio

# stripes role
stripes_user: okapi
stripes_group: okapi
stripes_okapi_port: 9130
stripes_okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ stripes_okapi_port }}"
stripes_home: /usr/share/folio/stripes
stripes_conf: /etc/folio/stripes
disable_auth: true
stripes_tenant: diku
folio_registry: https://repository.folio.org/repository/npm-folioci/
stripes_modules:
  - { name: "@folio/trivial", version: "^0.0.2-test" }
  - { name: "@folio/okapi-console", version: "^0.0.1-test" }
  - { name: "@folio/users", version: "^0.0.1-test" }
  - { name: "@folio/items", version: "^0.0.1-test" }


# stripes-core role
stripes_user: okapi
stripes_group: okapi
stripes_okapi_port: 9130
stripes_okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ stripes_okapi_port }}"
stripes_home: /usr/share/folio/stripes
stripes_conf: /etc/folio/stripes
stripes_tenant: diku
folio_registry: https://repository.folio.org/repository/npm-folioci/
folio_sample_modules_registry: https://repository.folio.org/repository/npm-folioci/

# tenant-data role
okapi_url: http://localhost:9130/

# ui-okapi-console
# also uses {{ stripes_home }} and from stripes-core dependency

# ui-users
# also uses {{ stripes_home }}, {{ stripes_conf }}, and
# {{ stripes_user }} from stripes-core dependency.
```

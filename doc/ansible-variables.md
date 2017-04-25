# Variables used in Ansible playbooks and roles

These could be overridden with `group_vars` or `host_vars`.

## YAML for variables with default values
```yaml
---
# common role
folio_user: folio
folio_group: folio


folio_apt_repo_url: https://repository.folio.org/packages/ubuntu
folio_apt_key_id: 469A4045
folio_apt_key_url: https://repository.folio.org/packages/debian/folio-apt-archive-key.asc

# there are currently two FOLIO repositories - 'testing' and xenial'
# 'xenial' contains releases only while 'testing' includes dev
# snapshots.   Default is to configure just the 'xenial' repo which
# the most stable.  If you want both, add 'testing' to this list.
folio_apt_repos: 
  - xenial

# docker-engine role
docker_users:
  - folio
folioci: false

# maven-3 role
maven_version: 3.3.9

# mod-auth-data role
okapi_port: 9130

okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"

pg_admin_user: folio_admin
pg_admin_password: folio_admin
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432

module_database: okapi_modules

mod_auth_modules:
  - { index: 0, module: permissions-module }
  - { index: 1, module: authtoken-module }
  - { index: 2, module: login-module }

admin_user: { username: diku_admin, password: admin, hash: 52DCA1934B2B32BEA274900A496DF162EC172C1E, salt: 483A7C864569B90C24A0A6151139FF0B95005B16, permissions: "\\\"perms.all\\\"" }

admin_permissions:
  - perms.all
  - login.all
  - users.all
  - module.trivial.enabled
  - module.users.enabled
  - module.items.enabled
  - module.scan.enabled
  - module.okapi-console.enabled
  - module.organization.enabled

# Permissions not defined in backend module descriptors
additional_permissions:
  - { permissionName: module.trivial.enabled, displayName: "UI: Trivial module is enabled", subPermissions: "[]", mutable: "false" }
  - { permissionName: module.users.enabled, displayName: "UI: Users module is enabled", subPermissions: "[]", mutable: "false" }
  - { permissionName: module.items.enabled, displayName: "UI: Items module is enabled", subPermissions: "[]", mutable: "false" }
  - { permissionName: module.scan.enabled, displayName: "UI: Scan module is enabled", subPermissions: "[]", mutable: "false" }
  - { permissionName: module.okapi-console.enabled, displayName: "UI: Okapi Console module is enabled", subPermissions: "[]", mutable: "false" }
  - { permissionName: module.organization.enabled, displayName: "UI: Organization module is enabled", subPermissions: "[]", mutable: "false" }

mod_auth_users:
  - username: auth_test1
    password: diku
    permissions:
      - module.trivial.enabled
      - module.users.enabled
      - module.items.enabled
      - module.scan.enabled
      - module.okapi-console.enabled
      - module.organization.enabled
  - username: auth_test2
    password: diku

# mod-circulation-data role
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
auth_required: false
admin_user: { username: diku_admin, password: admin }

# mod-metadata-data role
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
mod_metadata_modules:
  - { index: 0, module: inventory-storage }
  - { index: 1, module: inventory }
auth_required: false
admin_user: { username: diku_admin, password: admin }

# mod-users-bl-data role
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
admin_user: { username: diku_admin, password: admin }
mod_users_bl_permissions:
  - username: diku_admin
    permissions:
      - users-bl.all

# mod-users-data role
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
patron_groups:
  - { group: on_campus, desc: On-campus }
  - { group: off_campus, desc: Off-campus }
  - { group: other, desc: Other }
auth_required: false
admin_user: { username: diku_admin, password: admin }

# okapi role
okapi_role: cluster
# 'eth0' is the default ec2 network interface. May be different on other systems
okapi_interface: eth0
okapi_cluster_port: 9001
okapi_cluster_config_file: ""
okapi_port: 9130
okapi_port_start: 9131
okapi_port_end: 9141
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
okapi_host: "{{ ansible_default_ipv4.address }}"

# change to 'postgres' for postgres backend
okapi_storage: inmemory

pg_host: localhost
pg_port: 5432
pg_admin_user: folio_admin
pg_admin_password: folio_admin
okapidb_user: okapi
okapidb_password: okapi25
okapidb_name: okapi
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

# okapi-deploy-modules role
folio_user: folio
folio_conf: /etc/folio
okapi_deploy_home: /usr/share/folio/okapi-deploy
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
docker_repo: folioci  
pg_admin_user: folio_admin
pg_admin_password: folio_admin
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
folio_modules: [ ]

# okapi-register-modules role
folio_user: folio
folio_conf: /etc/folio
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
folio_modules: [ ]

# okapi-src role
okapi_src_home: /opt/okapi-src
okapi_home: /opt/okapi

# okapi-test role
# also uses {{ okapi_src_home }} from okapi-src dependency

# okapi-undeploy role
okapi_home: /usr/share/folio/okapi
folio_user: okapi
folio_group: okapi

# postgresql role
pg_admin_user: folio_admin
pg_admin_password: folio_admin

# raml-module-builder role
raml_module_builder_home: /opt/raml-module-builder

# sdkman role
sdkman_user: folio

# stripes-docker role
# Use a preconfigured gitbub stripes platform
with_github: true
stripes_github_project: https://github.com/folio-org/stripes-demo-platform

# OR specify stripes configuration here and configure from ansible templates 
stripes_core_version: "^0.7.0"
stripes_modules:
  - { name: "@folio/users", version: "^1.1.0" }
  - { name: "@folio/items", version: "^1.1.0" }
  - { name: "@folio/scan", version: "^0.2.0" }
  - { name: "@folio/trivial", version: "^0.0.2-test" }

# disable okapi-console - https://issues.folio.org/browse/STRIPES-264
#  - { name: "@folio/okapi-console", version: "^0.0.1-test" }


# Other relevant vars
stripes_conf_dir: /etc/folio/stripes
stripes_okapi_port: 9130
disable_auth: false
stripes_okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ stripes_okapi_port }}"
stripes_tenant: diku
# host address to map container to. '127.0.0.1' by default  
stripes_host_address: '127.0.0.1'
#
# optional nginx proxy. disabled by default.
#
with_nginx: false
nginx_port: 80
# can override with ec2_facts 'ansible_ec2_public_hostname' for AWS
nginx_servername: localhost

# NPM repository settings
folio_npm_base_url: repository.folio.org/repository/
folio_npm_repo: npm-folio

#
# Disabled by default
# 
npm_proxy: false
npm_authtoken: ''

# tenant-data role
okapi_url: http://localhost:9130/
```

## Deprecated roles
```yaml
---
# mod-auth role
# folio_user needs to be a user with access to Docker
folio_user: folio
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
  - { index: 0, module: authtoken-module, docker_image: folioci/mod-authtoken, mod_descriptor: "https://raw.githubusercontent.com/folio-org/mod-auth/master/authtoken_module/ModuleDescriptor.json" }
  - { index: 1, module: login-module, docker_image: folioci/mod-login, mod_descriptor: "https://raw.githubusercontent.com/folio-org/mod-auth/master/login_module/ModuleDescriptor.json" }
  - { index: 2, module: permissions-module, docker_image: folioci/mod-permissions, mod_descriptor: "https://raw.githubusercontent.com/folio-org/mod-auth/master/permissions_module/ModuleDescriptor.json" }
 {{ pg_admin_user }} and {{ pg_admin_password }} from postgresql dependency

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

# mod-circulation role
# folio_user needs to be a user with access to Docker
folio_user: folio
mod_circulation_home: /usr/share/folio/mod-circulation
mod_circulation_conf: /etc/folio/mod-circulation
mod_circulation_mod_descriptor: https://raw.githubusercontent.com/folio-org/mod-circulation/master/ModuleDescriptor-1.0.json
mod_circulation_version: latest
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"

# mod-loan-storage role
# folio_user needs to be a user with access to Docker
folio_user: folio
mod_loan_storage_home: /usr/share/folio/mod-loan-storage
mod_loan_storage_conf: /etc/folio/mod-loan-storage
mod_loan_storage_mod_descriptor: https://raw.githubusercontent.com/folio-org/mod-loan-storage/master/ModuleDescriptor-1.0.json
mod_loan_storage_version: latest
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
pg_user: "{{ pg_admin_user }}"
pg_password: "{{ pg_admin_password }}"
mod_loan_storage_db: mod_loan_storage
# {{ pg_admin_user }} and {{ pg_admin_password }} from postgresql dependency

# mod-metadata role
# folio_user needs to be a user with access to Docker
folio_user: folio
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
  - { index: 0, module: inventory-storage, mod_descriptor: "https://raw.githubusercontent.com/folio-org/mod-metadata/master/inventory-storage/ModuleDescriptor-v1.0.json", docker_image: folioci/mod-inventory-storage }
  - { index: 1, module: inventory, mod_descriptor: "https://raw.githubusercontent.com/folio-org/mod-metadata/master/inventory/ModuleDescriptor-v1.0.json", docker_image: folioci/mod-inventory }
# {{ pg_admin_user }} and {{ pg_admin_password }} from postgresql dependency

# mod-metadata-build role
mod_metadata_src_home: /opt/mod-metadata-src
# {{ folio_user }} and {{ folio_group }} from common dependency

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
folio_user: folio
mod_users_home: /usr/share/folio/mod-users
mod_users_conf: /etc/folio/mod-users
mod_users_mod_descriptor: https://raw.githubusercontent.com/folio-org/mod-users/master/ModuleDescriptor.json
mod_users_version: latest
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
pg_user: "{{ pg_admin_user }}"
pg_password: "{{ pg_admin_password }}"
mod_users_db: mod_users
# {{ pg_admin_user }} and {{ pg_admin_password }} from postgresql dependency

# mod-users-bl role
# folio_user needs to be a user with access to Docker
folio_user: folio
mod_users_bl_home: /usr/share/folio/mod-users-bl
mod_users_bl_conf: /etc/folio/mod-users-bl
mod_users_bl_version: latest
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"

# mod-users-build role
mod_users_src_home: /opt/mod-users-src
# {{ folio_user }} and {{ folio_group }} from common dependency

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
# okapi-demo role
okapi_src_home: /opt/okapi-src
okapi_home: /opt/okapi
okapi_pg_user: okapi
okapi_pg_password: okapi25
# {{ folio_user }} and {{ folio_group }} from common dependency

# okapi-docker role
okapi_src_home: /opt/okapi-src
# also uses {{ folio_group }} and {{ folio_user }} from common dependency

# stripes role
stripes_user: okapi
stripes_group: okapi
stripes_okapi_port: 9130
stripes_okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ stripes_okapi_port }}"
stripes_home: /usr/share/folio/stripes
stripes_conf: /etc/folio/stripes
disable_auth: false
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

# ui-okapi-console
# also uses {{ stripes_home }} and from stripes-core dependency

# ui-users
# also uses {{ stripes_home }}, {{ stripes_conf }}, and
# {{ stripes_user }} from stripes-core dependency.
```

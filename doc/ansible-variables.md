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

# maven-3 role
maven_version: 3.3.9

# mod-auth role
mod_auth_home: /opt/mod-auth
mod_auth_src_home: /opt/mod-auth-src
okapi_url: http://localhost:9130/
auth_modules:
  - { index: 0, module: login }
  - { index: 1, module: authtoken }
  - { index: 2, module: permissions }
# {{ folio_user }} and {{ folio_group }} from common dependency
# {{ okapi_home }} from okapi-undeploy dependency 

# mod-auth-demo role
# {{ mod_auth_home }}, {{ folio_user }}, {{ folio_group }},
# {{ okapi_url }}, {{ auth_modules }} from mod-auth dependency

# mod-circulation-build role
mod_circulation_src_home: /opt/mod-circulation-src

# mod-circulation-docker role
# also uses {{ mod_circulation_src_home }} from mod-circulation-build dependency

# mod-metadata-build role
mod_metadata_src_home: /opt/mod-metadata-src
# {{ folio_user }} and {{ folio_group }} from common dependency

# mod-metadata-data role
mod_metadata_src_home: /opt/mod-metadata-src
# {{ okapi_url }} from tenant-data
# {{ folio_user }} and {{ folio_group }} from common dependency

# mod-metadata-demo role
mod_metadata_home: /opt/mod-metadata
okapi_url: http://localhost:9130/
mod_metadata_pg_user: mod_metadata
mod_metadata_pg_password: mod_metadata25
mod_metadata_db: mod_metadata
# {{ mod_metadata_src_home }} from mod-metadata-build dependency
# {{ folio_user }} and {{ folio_group }} from common dependency
# {{ okapi_home }} from okapi-undeploy dependency 

# mod-users role
# folio_user needs to be a user with access to Docker
folio_user: okapi
mod_users_home: /usr/share/folio/mod-users
mod_users_conf: /etc/folio/mod-users
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
okapi_host: "{{ ansible_default_ipv4.address }}"

# mod-users-build role
mod_users_src_home: /opt/mod-users-src
# {{ folio_user }} and {{ folio_group }} from common dependency

# mod-users-data role
# {{ okapi_url }} from tenant-data

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
okapi_pg_user: okapi
okapi_pg_password: okapi25
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

# stripes-core role
stripes_home: /opt/stripes

# tenant-data role
okapi_url: http://localhost:9130/

# ui-okapi-console
# also uses {{ stripes_home }} from stripes-core dependency

# ui-users
# also uses {{ stripes_home }} from stripes-core dependency
```

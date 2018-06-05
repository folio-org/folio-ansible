# okapi-tenant-install

Ansible role to install tenant software from a [TenantModuleDescriptorList](https://github.com/folio-org/okapi/blob/master/okapi-core/src/main/raml/TenantModuleDescriptorList.json) JSON file. See also [TenantModuleDescriptor](https://github.com/folio-org/okapi/blob/master/okapi-core/src/main/raml/TenantModuleDescriptor.json). The approach is to get the JSON file from http://folio-snapshot-stable.aws.indexdata.com/install.json.

## Assumptions

* The role assumes that the required modules are already available. This can be accomplished in these ways:
  * The modules are already deployed to the Okapi `/_/discovery` endpoint using a [DeploymentDescriptor](https://github.com/folio-org/okapi/blob/master/okapi-core/src/main/raml/DeploymentDescriptor.json).
  * The [ModuleDescriptor](https://github.com/folio-org/okapi/blob/master/okapi-core/src/main/raml/ModuleDescriptor.json) for the module contains a [LaunchDescriptor](https://github.com/folio-org/okapi/blob/master/okapi-core/src/main/raml/LaunchDescriptor.json) to tell Okapi how to deploy the module.

## Prerequisites

* A running Okapi system
* Roles:
  * okapi-pull (to load the latest module descriptors from the repository)
  * tenant-data (to create a tenant)

## Variables

```yaml
---
# defaults
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
install_url: http://folio-snapshot-stable.aws.indexdata.com/install.json
tenant: diku
install_timeout: 600
install_deploy: no
pg_admin_user: folio_admin
pg_admin_password: folio_admin
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
module_database: okapi_modules
module_env:
  - db.host: "{{ pg_host }}"
  - db.port: "{{ pg_port }}"
  - db.database: "{{ module_database }}"
  - db.username: "{{ pg_admin_user }}"
  - db.password: "{{ pg_admin_password }}"
```

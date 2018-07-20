# okapi-tenant-modules

Ansible role for deploying and enabling modules for a tenant based on an install.json file.

## Prerequisites

* A running Okapi system with:
  * A database available for module data (you can use the `postgresql` role to provision a database and create an admin user).
  * Registered module descriptors for all modules to be deployed. All module descriptors must contain a launch descriptor telling Okapi how to deploy the module (you can use the `okapi-pull` role to populate the module registry).
  * The ability to deploy modules, either using `exec` or Docker (you can use the `docker-engine` role to install Docker on the target system).
  * A tenant (you can use the `tenant-data` role to create a tenant).

* An install file containing a JSON array of modules for posting to the `/_/proxy/tenants/<tenantId>/install?deploy` endpoint for deployment. This can optionally point to a URL. A [sample file](roles/okapi-install.json) is available in the `files` directory of this role.

* An install file containing a JSON array of modules for posting to the `/_/proxy/tenants/<tenantId>/install` endpoint to enable the modules without deployment. This can optionally point to a URL. A [sample file](roles/stripes-install.json) is available in the `files` directory of this role.

## Usage

Invoke the role in a playbook, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - postgresql
    - docker-engine
    - okapi-pull
    - tenant-data
    - okapi-tenant-modules
```

## Variables

```yaml
---
# defaults
create_db: yes
pg_admin_user: folio_admin
pg_admin_password: folio_admin
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
pg_max_pool_size: 5
module_database: okapi_modules
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
module_env:
  - { name: db.host, value: "{{ pg_host }}" }
  - { name: db.port, value: "{{ pg_port }}" }
  - { name: db.database, value: "{{ module_database }}" }
  - { name: db.username, value: "{{ pg_admin_user }}" }
  - { name: db.password, value: "{{ pg_admin_password }}" }
  - { name: db.maxPoolSize, value: "{{ pg_max_pool_size }}" }

tenant: diku
deploy_timeout: 600

# Define one or more of these variables to post install JSON to Okapi. They are posted in the order listed here.
# deploy_file:
# deploy_url:
# enable_file:
# enable_url:
```

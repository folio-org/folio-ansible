# okapi-tenant-deploy

Ansible role for deploying and enabling modules for a tenant based on the `folio_modules` variable. Optionally, this role can also create a database to hold tenant data.

## Prerequisites

* A running Okapi system with
  * Registered module descriptors for all modules to be deployed and enabled. All module descriptors for modules that require deployment must contain a launch descriptor telling Okapi how to deploy the module (you can use the `okapi-pull` or the `okapi-register-modules` roles to populate the module registry).
  * The ability to deploy modules, either using `exec` or Docker (you can use the `docker-engine` role to install Docker on the target system).
  * A tenant (you can use the `tenant-data` role to create a tenant).

* A PostgreSQL database server to create a database to hold tenant data (you can use the `postgresql` role to set up the server).

* The `folio_modules` variable, defined globally or passed along by another role.

## Usage

Invoke the role in a playbook, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - okapi
    - docker-engine
    - okapi-pull
    - tenant-data
    - role: okapi-tenant-deploy
      folio_modules:
        - name: mod-login # this is the base of the module name
          version: 3.1.0 # if undefined, Okapi will resolve to the most recent version that satisfies dependencies
          # either url or deploy can be used to register the module with Okapi's /_/discovery service
          # If the module is already registered, neither are required
          # url takes precedence over deploy
          # url: "http://my-mod-login:8081"
          deploy: yes # if defined, Okapi will attempt to deploy the module using the launch descriptor embedded in the registered module descriptor
```

## Variables

```yaml
---
# defaults

# Database setup
create_db: yes
pg_admin_user: folio_admin
pg_admin_password: folio_admin
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
pg_max_pool_size: 5
module_database: okapi_modules
module_env:
  - { name: db.host, value: "{{ pg_host }}" }
  - { name: db.port, value: "{{ pg_port }}" }
  - { name: db.database, value: "{{ module_database }}" }
  - { name: db.username, value: "{{ pg_admin_user }}" }
  - { name: db.password, value: "{{ pg_admin_password }}" }
  - { name: db.maxPoolSize, value: "{{ pg_max_pool_size }}" }

# If the module_env list is populated, it will set global module environment variables
# These environment variables can be overridden by the docker_env property of the folio_modules entries

# Okapi setup
folio_modules: []
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
tenant: diku
deploy_timeout: 900
```

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
          # tenant parameters to pass on tenant initialization
          tenant_parameters:
            - { name: loadReference, value: "true" }
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
pg_maint_db: postgres
pg_max_pool_size: 5
module_database: okapi_modules

# Kafka setup
kafka_host: "{{ ansible_default_ipv4.address }}"
kafka_port: 9092
kafka_topic_env: "FOLIO"

# Elasticsearch setup
elasticsearch_host: "{{ ansible_default_ipv4.address }}"
elasticsearch_port: 9301

module_env:
  - { name: DB_HOST, value: "{{ pg_host }}" }
  - { name: DB_PORT, value: "{{ pg_port }}" }
  - { name: DB_DATABASE, value: "{{ module_database }}" }
  - { name: DB_USERNAME, value: "{{ pg_admin_user }}" }
  - { name: DB_PASSWORD, value: "{{ pg_admin_password }}" }
  - { name: DB_MAXPOOLSIZE, value: "{{ pg_max_pool_size }}" }
  - { name: KAFKA_HOST, value: "{{ kafka_host }}" }
  - { name: KAFKA_PORT, value: "{{ kafka_port }}" }
  - { name: ENV, value: "{{ kafka_topic_env }}"
  - { name: ELASTICSEARCH_HOST, value: "{{ elasticsearch_host }}" }
  - { name: ELASTICSEARCH_PORT, value: "{{ elasticsearch_port }}" }

# If the module_env list is populated, it will set global module environment variables
# These environment variables can be overridden by the docker_env property of the folio_modules entries

# Okapi setup
folio_install_type: single_server
folio_modules: []
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
tenant: diku
deploy_timeout: 900

# Where to save the install.json files
save_install: yes
save_dir: /etc/folio/stripes
```

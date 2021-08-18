# okapi-deployment

Ansible role to build deployment descriptors and post them to Okapi's `/_/discovery/modules` endpoint based on the `folio_modules` variable. The modules must be already registered with Okapi's `/_/proxy/modules` endpoint (usually by pulling them from a central module registry) and include `launchDescriptor` key.

The `folio_modules` variable can be populated by the `build-module-list` role, or from a variables file. See the `okapi-register-modules` role for format of the variable.

This role is mostly useful in constructing deployment descriptors that override the builtin `launchDescriptor` key of the registered module descriptors.

## Prerequisites

* The `folio_modules` variable should be populated with a list of modules from a variables file or from the `build-module-list` role

* A running Okapi system with registered module descriptors for all modules in the `folio_modules` variable. Module descriptors for modules to be deployed must contain a launch descriptor telling Okapi how to deploy the module (you can use the `okapi-pull` role to populate the module registry).

* A running PostgreSQL server for module data (you can use the `postgresql` role to set up a local PostgreSQL server).

## Usage

Invoke the role in a playbook, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: okapi-deployment
```

## Possible enhancements

* `node_id` could come from the `folio_modules` variable to allow for deploying on multiple nodes in a clustered environment

* Add support for updating the `dockerPull` key

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

# If the module_env list is populated, it will set global module environment variables
# These environment variables can be overridden by the docker_env property of the folio_modules entries
module_env:
  - { name: DB_HOST, value: "{{ pg_host }}" }
  - { name: DB_PORT, value: "{{ pg_port }}" }
  - { name: DB_DATABASE, value: "{{ module_database }}" }
  - { name: DB_USERNAME, value: "{{ pg_admin_user }}" }
  - { name: DB_PASSWORD, value: "{{ pg_admin_password }}" }
  - { name: DB_MAXPOOLSIZE, value: "{{ pg_max_pool_size }}" }
  - { name: KAFKA_HOST, value: "{{ kafka_host }}" }
  - { name: KAFKA_PORT, value: "{{ kafka_port }}" }
  - { name: ENV, value: "{{ kafka_topic_env }}" }
  - { name: ELASTICSEARCH_HOST, value: "{{ elasticsearch_host }}" }
  - { name: ELASTICSEARCH_PORT, value: "{{ elasticsearch_port }}" }

# Okapi setup
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
node_id: "{{ ansible_default_ipv4.address }}"
```

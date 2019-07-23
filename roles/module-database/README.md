# module-database

Ansible role for provisioning a database for module data, according to the requirements of the [RAML Module Builder](https://github.com/folio-org/raml-module-builder). This role will:

1. Provision a PostgreSQL administrative role, used by RMB to create per-tenant module schemas and roles.
2. Provision a PostgreSQL database on the configured PostgreSQL server for module data.

## Caveats/Limitations

This role currently provisions the PostgreSQL administrative role as a PostgreSQL superuser, due to a limitation in RMB. See https://issues.folio.org/browse/RMB-360.

## Prerequisites

* Administrative access to a running PostgreSQL server

## Usage

Invoke the role in a playbook, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: module-database
```

Or include it as a dependency in a role, e.g.:

```yaml
dependencies:
  - { role: module-database }
```

## Variables

```yaml
---
# pg_admin credentials should be for a superuser
pg_admin_user: folio_admin
pg_admin_password: folio_admin
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
pg_maint_db: postgres
module_admin_user: folio_module_admin
module_admin_password: folio_module_admin
module_database: okapi_modules
```

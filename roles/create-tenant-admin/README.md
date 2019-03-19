# create-tenant-admin

Bootstrap an admin user. This role will disable authtoken for a tenant, create a user, permissions user, credentials, and service-points-users record, assigning the permission `permissions.all` to the user, then re-enable mod-authtoken.

## Prerequisites

* A running Okapi system with the users, login, and permissions interfaces enabled for the tenant.
  * If `authtoken` is enabled for the tenant, this role will disable and re-enable it.
  * If `service-points-users` is enabled for the tenant, this role will create a service-points-users record.

## Usage

Invoke the role in a playbook, optionally with variables defined, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: create-tenant-admin
      admin_user:
        username: administrator
        password: V3ryS3cr3tP@ssw0rd
        first_name:
        last_name: Superuser
        email: admin@example.org
```

## Variables

```yaml
---
# defaults
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
tenant: diku
admin_user:
  username: diku_admin
  password: admin
  first_name: DIKU
  last_name: ADMINISTRATOR
  email: admin@diku.example.org
```

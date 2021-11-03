# create-tenant-admin

Bootstrap an admin user. This role will disable authtoken for a tenant, create a user, permissions user, credentials, and service-points-users record, along with the necessary permissions to allow the user to assign itself or other users any required permissions (by using the [tenant-admin-permissions](../tenant-admin-permissions) role, for example).

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
        perms_users_assign: yes
```

## Notes

The behavior of this role depends on the variable `perms_users_assign`. If that variable is true, the user is given the extra permissions `perms.users.assign.immutable` and `perms.users.assign.mutable` for compatibility with versions of mod-permissions later than v5.15.0-SNAPSHOT.121. Otherwise, the default behavior is to give the user only the `perms.all` permission.

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
perms_users_assign: no
```

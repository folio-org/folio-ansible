# okapi-secure

Ansible role for securing a running Okapi installation using the security guides:

* https://github.com/folio-org/okapi/blob/master/doc/guide.md#securing-okapi

* https://github.com/folio-org/okapi/blob/master/doc/securing.md

This task enables mod-users, mod-login, and mod-permissions for the okapi supertenant, creates a superuser with required permission sets, and then enables mod-authtoken.

## Prerequisites

* A running Okapi system with mod-users, mod-login, mod-permissions, and mod-authtoken already deployed (this role does not attempt to deploy the modules)

## Usage

Invoke the role in a playbook, e.g.:
```yaml
- hosts: my-folio-test
  roles:
    - role: okapi-secure
      superuser_username: okapi_superuser
      superuser_password: mysecret
      perms_users_assign: yes
```

## Defaults
```yaml
---
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
superuser_username: super_admin
superuser_password: admin
user_only: false
perms_users_assign: false
```

## Notes
This is not idempotent. Once the Okapi supertenant is secured, roles that assume Okapi is not locked down cannot be re-executed.

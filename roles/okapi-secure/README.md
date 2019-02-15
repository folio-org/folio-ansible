# okapi-secure

Ansible role to securing a running Okapi installation using the security guides:

* https://github.com/folio-org/okapi/blob/master/doc/guide.md#securing-okapi

* https://github.com/folio-org/okapi/blob/master/doc/securing.md

This taks enable mod-users and mod-permissions for the okapi supertenant, creates a superuser with required permission sets, and then enables mod-authtoken.

## defaults
```
---
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
superuser_username: supertenant_admin
superuser_password: supertenant_pass
tenant:  supertenant   
```

## Notes
This is not idempotent. Once the Okapi supertenant is secured, roles that assume Okapi is not locked down cannot be re-executed.

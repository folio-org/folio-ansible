# create-user

Create a FOLIO user with user record, credentials, and permissions

## Prerequisites

* A running Okapi system with the users, login, and permissions interfaces enabled for the tenant.
* An admin user that can be used to create the user

## Usage

Invoke the role in a playbook with variables defined, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: create-user
      username: test_user
      password: my!Secret
      first_name: Jo
      last_name: Tester
      email: tester@example.org
      permissions:
      - permissions.all
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
```

The `username` and `password` variables are required with no defaults.

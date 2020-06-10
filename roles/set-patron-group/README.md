# set-patron-group

Some procedures require a default patronGroup for the admin user.

## Prerequisites

* The tenant `admin_user` (see [Variables](#variables) below) needs to have all required permissions.

## Usage

Invoke the role in a playbook with variables defined, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: set-patron-group
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
group_name: staff
```

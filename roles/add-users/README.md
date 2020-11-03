# add-users

Ansible role to run the `add-users.js` script from [folio-tools](https://github.com/folio-org/folio-tools). This script creates custom users from permissions sets defined in JSON-formatted files. See https://github.com/folio-org/folio-tools/tree/master/add-users for more details.

## Prerequisites

This role clones the folio-tools repository from GitHub and uses NodeJS to run the script. It requires both git and node to be installed on the target system. The [nodejs role](../nodejs) from this project is listed as a dependency.

## Usage

Invoke the role in a playbook, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: add-users
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

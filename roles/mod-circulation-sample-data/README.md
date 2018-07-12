# mod-circulation-sample-data

Ansible role for loading circulation sample data from a module repository. The data is generated based on the running system.

## Prerequisites

* A running Okapi system with mod-users, mod-circulation-storage, and mod-circulation in place, enabled for the tenant. The `admin_user` (see [Variables](#variables) below) needs to have all required permissions.
* A sufficient number of active users (6 or more) in user storage to generate the loan and request data.
* *Note*: The mod-users-data role is a dependency for this role.

## Usage

Invoke the role in a playbook, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - mod-circulation-sample-data
```

## Variables

```yaml
---
# defaults
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
auth_required: false
admin_user: 
  username: diku_admin
  password: admin

tenant: diku
```


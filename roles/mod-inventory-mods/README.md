# mod-inventory-mods

Load MODS data into mod-inventory. The MODS files are in the `files` directory. An XSLT stylesheet in the `util` directory will add holdings on to a MODS file if you want to create your own.

## Prerequisites

* A running Okapi system with mod-inventory and mod-inventory-storage, both enabled for the tenant. The `admin_user` (see [Variables](#variables) below) needs to have all required permissions.

## Usage

Invoke the role in a playbook with variables defined, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: mod-inventory-mods
      auth_required: yes
```

## Variables

```yaml
---
# defaults
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
auth_required: no

admin_user: 
  username: diku_admin 
  password: admin 

tenant: diku
load_mods_larger: false
```

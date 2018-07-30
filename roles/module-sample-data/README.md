# module-sample-data

A generic Ansible role for loading sample data from a module repository.

## Prerequisites

* A running Okapi system with the module in place, enabled for the tenant. The `admin_user` (see [Variables](#variables) below) needs to have all required permissions.
* [Git](https://git-scm.com) must be installed on the Ansible control host

## Usage

Invoke the role in a playbook with variables defined, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: module-sample-data
      module_name: mod-vendors
      repository: https://github.com/folio-org/mod-vendors
      files:
        - { load_endpoint: /vendor, fileglob: sample-data/vendors/*.json }
```

### Usage notes

* If you use the magic variable `$filename` as part of the `load_endpoint`, the filename of each file (stripped of the file extension) is substituted into the string for the load endpoint.
* If there is only one valid status code from the web service you are loading to (for example, you are using a PUT method, which always updates the data), set `dup_override` to the same value as `updated_code`.

A more complex example:

```yaml
- hosts: my-folio-test
  roles:
    - role: module-sample-data
      module_name: mod-inventory-storage
      repository: https://github.com/folio-org/mod-inventory-storage
      files:
        - { load_endpoint: /instance-storage/instances/$filename/source-record/marc-json, fileglob: sample-data/instance-source-records/*.json, http_method: PUT, dup_override: 204, updated_code: 204 }
```

## Variables

```yaml
---
# defaults
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
auth_required: no
top_down_install: no

admin_user: 
  username: diku_admin 
  password: admin 
  perms_user_id: "{{ admin_perms_id|default('2408ae64-56ad-4177-9024-1e35fe5d895c') }}"

tenant: diku

update_repo: yes
force_repo_update: yes
module_version: HEAD
working_dir: /tmp/module-sample-data

# Status code for duplicate key
duplicate_key_error: 422

# undefined by default, need to be defined for the role to work
# Module name, e.g. mod-vendors
module_name:
# Git URL for repository, e.g. https://github.com/folio-org/mod-vendors
repository:
# List of files to load per endpoint, e.g. { load_endpoint: /vendor, fileglob: sample-data/vendors/*.json }
# Override duplicate_key_error here with variable dup_override
# Override default HTTP method with variable http_method (default is POST)
# Override default HTTP code for updated record with variable updated_code (default is 201)
files: []
```

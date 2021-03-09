# cron-jobs

Ansible role installs the `folioCronServicerun` python package with pip3. Once installed the package runs `config` to set up credential file and `setup` to install crontab jobs. See https://github.com/folio-org/folio-tools/tree/master/folio-cron-jobs for more details.

## Prerequisites

This role requires pip3 and python3.

## Usage

Invoke the role in a playbook, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: cron-jobs
```

## Variables

```yaml
---
# defaults
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
folio_cron_branch: master
admin_user:
  username: diku_admin
  password: admin
```

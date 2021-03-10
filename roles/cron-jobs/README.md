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
tenant: diku
admin_user:
  username: diku_admin
  password: admin
# Optional, will default to config from folioCronService package
# config_dir: folio_cron_jobs # Optional, default to "folio_cron_jobs" in Ansible user's directory
# folio_cron_jobs:
#   - name: scheduled-age-to-lost-fee-charging
#     user_config_section: DEFAULT # Optional, default "DEFAULT"
#     cron_time: "*/30 * * * *"
#     tenant: diku # Optional, default "{{ tenant }}"
#     api_path: "/circulation/scheduled-age-to-lost-fee-charging"
#     method: POST
#     data: # Optional, default to empty object
#       active: "true" # note quoted value, these are query params
```

## TODO

This role creates the crontab jobs for the Ansible user, which is probably not optimal. Job definitions and credentials are stored in the user's folder, along with log files. It should be fixed to use the `folio` system user, store configuration in `/etc/folio`, and logs in `/var/log/folio`.

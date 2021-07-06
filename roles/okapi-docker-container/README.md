# okapi-docker-container

Ansible role to deploy Okapi on a host as a Docker container running on the local Docker daemon.

For more information on Okapi, please see the [Okapi Guide and Reference](https://github.com/folio-org/okapi/blob/master/doc/guide.md).

## Notes

* This role uses Docker host networking to run Okapi as part of the target host's network stack. This helps to make this role a drop-in replacement for the [okapi](../okapi) role, which installs Okapi as a Debian package.

* Since this role is designed for quickly spinning up an Okapi environment for development purposes, Okapi will run with the `dev` command (i.e. in a single-node deployment, not clustered).

## Usage

Invoke the role in a playbook, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: okapi-docker-container
```

## Variables

```yaml
---
# Defaults
okapi_docker_org: folioorg
okapi_version: latest
okapi_port: 9130
okapi_volumes:
   - /etc/folio/okapi/okapi.json

okapi_port_start: 9131
okapi_port_end: 9661

okapi_host: "{{ ansible_default_ipv4.address }}"
okapi_nodename: "{{ ansible_default_ipv4.address }}"

okapi_storage: inmemory
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
okapi_dockerurl: http://localhost:4243

okapi_default_host: "{{ ansible_default_ipv4.address }}"
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
pg_admin_user: folio_admin
pg_admin_password: folio_admin
pg_maint_db: postgres
okapidb_user: okapi
okapidb_password: okapi25
okapidb_name: okapi

# dockerRegistries property
# List of objects, see https://github.com/folio-org/okapi/blob/master/doc/guide.md#okapi-configuration
# no default - sample below
# okapi_docker_registries:
#   - username: dockerUser
#     password: ...

# Set additional Java opts here, e.g.:
# okapi_java_opts:
#   - "-Xss20M"
# These will be added to the JAVA_OPTIONS environment variable for the container
okapi_java_opts: []
```

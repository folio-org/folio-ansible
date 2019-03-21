# build-install-json

This role uses the Okapi API to examine the module configuration for a tenant and creates two files in the FOLIO configuration directory:

1. `okapi-install.json` -- the backend modules enabled for the tenant
2. `stripes-install.json` -- the Stripes modules enabled for the tenant

The role relies on the convention that backend module IDs are prefixed with `mod-` (e.g. `mod-inventory`), while the frontend module IDs are prefixed with `folio_` (e.g. `folio_inventory`).

The files created by this role can be picked up by the [`stripes-docker`](../stripes-docker) role for inclusion in the stripes nginx container. They are in the format required for the [Okapi tenant install API](https://github.com/folio-org/okapi/blob/master/doc/guide.md#install-modules-per-tenant).

## Prerequisites

This role assumes a running Okapi system.

## Usage

Invoke this role in a playbook for your target system, e.g.:
```yaml
- name: Generate install files
  hosts: my-folio-test
  roles:
    - role: build-install-json
      tenant: my-tenant
```

## Variables

```yaml
---
# Defaults
# Okapi setup
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
tenant: diku
folio_conf: /etc/folio
```

# stripes-nginx

Ansible role to set up nginx for proxying "edge" modules.

This role will set up an nginx configuration to listen on a port and proxy requests to various "edge" modules, e.g. [edge-rtac](https://github.com/folio-org/edge-rtac). See the [edge-module](../edge-module/README.md) role for setting up a module.

## Variables

```yaml
---
# defaults
edge_listen_port: 8000
edge_server_name:
  - "{{ ansible_default_ipv4.address }}"
```

## TODO

* Add option for configuring https

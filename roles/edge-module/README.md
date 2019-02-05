# edge-module

## TODO set up module configuration (https://github.com/folio-org/edge-common)

Ansible role to set up an "edge" module (e.g. [edge-rtac](https://github.com/folio-org/edge-rtac)) that uses an HTTP API.

This role deploys an edge module as a Docker container, and sets up nginx to proxy it.

## Prerequisites

* This role relies on a Docker daemon to deploy edge module containers. You can use the [docker-engine](../roles/docker-engine) role to set up and configure Docker locally on the host, or use another Docker instance.

* The edge module must be registered and initialized for the tenant. Managing Okapi module registration, tenant initialization, and dependency resolution are outside the scope of this role. You can use the [okapi-register-modules](../roles/okapi-register-modules/README.md), [okapi-deployment](../roles/okapi-deployment/README.md), and [okapi-tenant-deploy](../roles/okapi-tenant-deploy/README.md) roles for managing those tasks.

## Role dependencies

[edge-nginx](../roles/edge-nginx/README.md): installs nginx and sets up a base configuration file for proxying

## Usage

Invoke this role for each edge module you wish to set up. For example:

```yaml
- hosts: my-folio-test
  roles:
    - docker-engine
    - role: edge-module
      edge_module: edge-rtac
      edge_module_publish_port: 9700
      edge_module_path: /prod/rtac
      edge_module_expose_port: 8081
      edge_module_docker_env:
        JAVA_OPTIONS: "-Xmx256m"
```

## Known issues

* The role assumes that there is one nginx configuration for all edge modules. This can theoretically result in a route collision if module paths conflict.

* The role does not attempt to manage the published port of the container. This will result in conflicts if not managed.

## Variables
```yaml
---
# defaults

# Okapi setup
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
tenant: diku

# Docker setup
edge_docker_repo: folioci
edge_docker_host: unix://var/run/docker.sock
edge_module_host: localhost

# Module setup
# edge_module, and edge_module_publish_port, edge_module_path variables must be defined or the role will fail
# edge_module: edge-rtac
# edge_module_publish_port: 9700
# edge_module_path: /prod/rtac
edge_module_expose_port: 8081
edge_module_docker_env:
# sample Docker env
# edge_module_docker_env:
#   JAVA_OPTIONS: "-Xmx256m"
```

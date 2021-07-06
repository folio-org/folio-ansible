# edge-module

Ansible role to set up an "edge" module (e.g. [edge-rtac](https://github.com/folio-org/edge-rtac)).

This role deploys an edge module as a Docker container. By default it sets up nginx to proxy it (for HTTP APIs only).

## Prerequisites

* This role relies on a Docker daemon on the host to deploy edge module containers. You can use the [docker-engine](../roles/docker-engine) role to set up and configure Docker.

* The edge module must be registered and initialized for the tenant. Managing Okapi module registration, tenant initialization, and dependency resolution are outside the scope of this role. You can use the [okapi-register-modules](../roles/okapi-register-modules/README.md), [okapi-deployment](../roles/okapi-deployment/README.md), and [okapi-tenant-deploy](../roles/okapi-tenant-deploy/README.md) roles for managing those tasks.

* The FOLIO system in question should have the `users`, `login`, and `permissions` interfaces enabled for the tenant to provision the institutional user.

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
      inst_user_perms:
        - rtac.all
      edge_extra_tenants:
        - tenant_id: test_rtac
          inst_user:
            username: test-user
            password: test
```

## Known issues/limitations

* The role assumes that there is one nginx configuration for all edge modules. This can theoretically result in a route collision if module paths conflict.

* The role does not attempt to manage the published port of the container. This will result in conflicts if not managed.

* Because the edge modules rely on a file for configuring authentication, this role will only work with a local Docker daemon.

## Variables
```yaml
---
# defaults

# Okapi setup
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
tenant: diku
admin_user:
  username: diku_admin
  password: admin
auth_required: no

# Docker setup
edge_docker_repo: folioci
edge_conf_dir: /etc/folio/edge

# Institutional user
inst_user:
  username: "{{ tenant }}"
  password: "{{ tenant }}"
  personal:
    lastName: SYSTEM
    firstName: EDGE
  inst_user_perms: [ ]

# Extra tenants (not created in Okapi, used for API testing)
# Optional
# edge_extra_tenants:
#   - tenant_id: test_rtac
#     inst_user:
#       username: test-user
#       password: test

# Proxy through nginx
edge_nginx_proxy: yes

# HTTP version produced by module, default 1.0
# edge_http_version: 1.1

# Module setup
# edge_module, and edge_module_publish_port variables must be defined or the role will fail
# edge_module_path must be defined if proxying through nginx
# edge_module_path can take either a single value or a list
# edge_module: edge-rtac
# edge_module_publish_port: 9700
# edge_module_path: /prod/rtac

edge_module_expose_port: 8081
edge_module_docker_env:
# sample Docker env
# edge_module_docker_env:
#   JAVA_OPTIONS: "-Xmx256m"
edge_module_okapi_url: "{{ okapi_url }}"
edge_module_cmd: "-Dokapi_url={{ edge_module_okapi_url }} -Dsecure_store_props=/mnt/{{ edge_module }}-ephemeral.properties"
edge_module_memory: 256M
```

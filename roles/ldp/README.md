# ldp
Provisions LDP. This sets up an LDP database in postgres, plus an LDP server running in a docker container. See the [LDP Admin Guide](https://github.com/library-data-platform/ldp/blob/master/doc/Admin_Guide.md) for more details.

## Requirements
This role expects the postgres and docker-engine roles to have been previously executed. This role is inteded for single server type builds.

## Defaults
```
---
okapi_port: "9130"
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"

pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432
pg_admin_user: folio_admin
pg_admin_password: folio_admin
pg_maint_db: postgres
pg_host: "{{ ansible_default_ipv4.address }}"
pg_port: 5432


admin_user:
  username: diku_admin
  password: admin

tenant: diku

ldp_docker_image: folioci/ldp:latest
ldp_db: ldp
ldp_admin_user: ldpadmin
ldp_admin_password: diku_ldpadmin9367
ldpconfig_user: ldpconfig
ldpconfig_password: diku_ldpconfig9367
ldp_user: ldp
ldp_password: diku_ldp9367
```

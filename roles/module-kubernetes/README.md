# Backend Module Kubernetes
This role deploys FOLIO backend modules within a kubernetes namespace.    This role assumes there is a Kubernetes cluster and Postgres instance with database already created. Configure connection information for Kubernetes in `~/.kube/config`.

## Usage
```yml
---
- hosts: localhost
  connection: local
  roles:
    - role: module-kubernetes
      db_host: mypghost.domain.tld
      db_user: my_admin_user
      db_password: my_pg_pass
      modules: [mod-user,mod-..., mod-...]
```

## Defaults
```yml
---
namespace: default
kubeconfig: ~/.kube/config

# Okapi Variables (Role: okapi_kubernetes) from DB Connection
pg_host: localhost
pg_port: 5432
pg_admin_user: admin
pg_admin_password: password
okapi_db_user: okapi
okapi_db_password: okapi25
okapi_db_database: okapi
okapi_url: http://okapi:9130
ingress_dns: okapi-demo2.ci.folio.org

# New Varibles for this ROLE
# Backend Modules
module_list:
  - mod-users-15.7.0-SNAPSHOT.85

# Mod descriptor registry
folio_registry: http://folio-registry.aws.indexdata.com
folio_options_url: https://raw.githubusercontent.com/folio-org/folio-ansible/master/group_vars/snapshot
# DB connection
db_database: okapi_modules
db_maxpoolsize: 20
db_password: password
db_username: folio_admin

db_secret_name: db-connect

# Services
service_type: ClusterIP

# Set to present or absent
k8s_state: present

```

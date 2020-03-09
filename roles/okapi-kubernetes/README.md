# Okapi Kubernetes
This role deploys okapi running in cluster mode into a Kubernetes namespace. It will provision a database on the specified postgres host if one does not already exist. This role assumes there is a Kubernetes cluster and Postgres instance available. Configure connection information for Kubernetes in `~/.kube/config`.

## Usage
```yml
---
- hosts: localhost
  connection: local
  roles:
    - role: okapi-kubernetes
      pg_host: mypghost.domain.tld
      pg_admin_user: my_admin_user
      pg_admin_password: my_pg_pass
```

## Note on service account

Hazelcast uses a service account to be able to communicate with the Kubernetes API for load-balancing purposes. By default, this role uses the "default" service account. The role can also create a different service account if that is required. That behavior is controlled by the `sa_name` variable -- if it is not set to "default", a new service account will be created.

Note that service account names for Okapi must be unique within a cluster. If more than one Okapi deployment is required, you should _not_ use the "default" account.

## Defaults
```yml
---
namespace: default
kubeconfig: ~/.kube/config

create_db: false
create_ingress: false
create_rbac: false
# service account that will
# get hazelcast role binding
sa_name: default

app_label: okapi
deployment_name: okapi
ingress_alb_target: none
ingress_name: okapi
ingress_dns: none

okapi_url: http://okapi:9130
okapidb_user: okapi
okapidb_password: okapi25
okapidb_name: okapi
okapi_docker_repository: folioci
okapi_docker_image: okapi
okapi_docker_tag: latest

hazelcast_version: 3.12

folio_db_user: folio
folio_db_password: folio25
folio_db_database: folio_modules
folio_install_type: kubernetes

pg_host: localhost
pg_maint_db: postgres
pg_port: 5432

service_name: okapi
service_type: ClusterIP
```

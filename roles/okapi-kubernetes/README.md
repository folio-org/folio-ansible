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

## Defaults
```yml
---
namespace: default
kubeconfig: ~/.kube/config

app_label: okapi

deployment_name: okapi

okapi_url: http://okapi:9130
okapi_db_user: okapi
okapi_db_password: okapi25
okapi_db_database: okapi

pg_admin_user: pgadminuser
pg_admin_password: pgadminpass
pg_host: localhost
pg_port: 5432


service_name: okapi
service_type: ClusterIP
```
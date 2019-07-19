# Backend Module Kubernetes
This role deploys FOLIO backend modules within a kubernetes namespace.    This role assumes there is a Kubernetes cluster, Postgres instance, and databases/users already created. Cluster configure connection information for Kubernetes in `~/.kube/config`.


## Usage

### Ansible Playbook

```yml
---
- hosts: localhost
  connection: local
  roles:
    - role: module-kubernetes
      db_host: mypghost.domain.tld
      db_user: my_admin_user
      db_password: my_pg_pass
      module_list:
        - mod-users-15.7.0-SNAPSHOT.85
```
### Command line Options
With the CI/CD process can run this role from the command line. Publish each backend module to cluster after creation/push to docker hub. Run using [example-variables.json](./example-variables.json)

      $ ansible localhost -m include_role -a name=module-kubernetes -e '@example-variables.json'

## Defaults
```yml
---
# defaults file for module-kubernetes
namespace: default
kubeconfig: ~/.kube/config
# Okapi Variables from Anisble Role: okapi_kubernetes
pg_host: localhost
pg_port: 5432
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
db_database: okapi
db_maxpoolsize: 20
db_password: password
db_username: folio_admin
# Kubernetes Secret Name for Backend Module DB ENV 
db_secret_name: db-connect
# Services
service_type: ClusterIP
# Set to present or absent
k8s_state: present
```

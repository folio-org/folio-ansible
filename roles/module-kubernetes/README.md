# Backend Module Kubernetes
This role deploys FOLIO backend modules within a kubernetes namespace.    This role assumes there is a Kubernetes cluster, Postgres instance, and databases/users already created. Cluster configure connection information for Kubernetes in `~/.kube/config`.

The role sets up database connection information for the modules based on the requirements of the [RAML Module Builder](https://github.com/folio-org/raml-module-builder). The database connection information is in the form of a secret that is read into the container environment. RMB requires that the environment variables be:

```yaml
stringData:
  DB_DATABASE: {{ db_database }}
  DB_HOST: {{ pg_host }}
  DB_MAXPOOLSIZE: "{{ db_maxpoolsize }}"
  DB_PASSWORD: {{ db_password }}
  DB_PORT: "{{ pg_port }}"
  DB_USERNAME: {{ db_username }}
```

The role will optionally create a database for module data and a secret for the module environment.

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
With the CI/CD process, can run this role from the command line. Publish each backend module to cluster after creation/push to docker hub. Run using [example-variables.json](./example-variables.json)

      $ ansible localhost -m include_role -a name=module-kubernetes -e '@example-variables.json'

### Edge Modules
Ansible current role can handle `Vault` or `Ephemeral` Secure Store. The default is Ephemeral and uses `institutional_users` variable to set Institutional Users. Please refer to [Edge Vault Readme](vault-readme.md)


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
folio_registry: http://folio-registry.dev.folio.org
folio_options_url: https://raw.githubusercontent.com/folio-org/folio-ansible/master/group_vars/snapshot
# DB connection
pg_admin_user: folio_admin
pg_admin_password: folio_admin
pg_maint_db: postgres
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

# Optional tasks
create_db: yes
create_secret: yes
okapi_pull: yes

# Edge Modules
# Currently setup for either Vault or Ephemeral Store
# Varaibles
edge_secure_store: Vault or Ephemeral(Default)

# Common Edge Modules Configs
# Ephemeral set Institutional Users
institutional_users:
  - username: test
    password: test1234
    tenant: diku
# Vault
vault_token: < token to access Hasicorp Vault >
vault_addr: < https://hashicorpVaultaddress >
# set to true for deployment of pr preview module
preview: false
```

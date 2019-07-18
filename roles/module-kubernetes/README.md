# Backend Module Kubernetes
This role deploys FOLIO backend modules within a kubernetes namespace.   It will provision a database on the specified postgres host if one does not already exist. This role assumes there is a Kubernetes cluster and Postgres instance available. Configure connection information for Kubernetes in `~/.kube/config`.

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



If 

NOTES
registry="http://folio-registry.aws.indexdata.com"
query="/_/proxy/modules?filter={0}&latest=1&full=true"
for item in modules:
def meta_module(module_id):
    meta={}
    #itm=item['id']
    meta['id']=module_id
    meta['tag']="-".join(meta['id'].split('-')[-2:]) if 'SNAPSHOT' in meta['id'] else meta['id'].split('-')[-1]
    meta['module']=meta['id'][ : meta['id'].find(meta['tag'])-1]
    md=requests.get("{0}{1}".format(registry,query.format(meta['module'])))
    md=md.json()[0]
    meta['container_memory']=deep_get(md,"metadata.containerMemory")
    meta['database_connection']=deep_get(md,"metadata.databaseConnection")
    try:
      meta['port']=next(iter(deep_get(md,"launchDescriptor.dockerArgs.HostConfig.PortBindings")))
    except:
      meta['port']='8081/tcp'
      meta['warning']="Port not found in Module Descriptor. Used default port  8081"
    print(meta)

--python3
from functools import reduce

def deep_get(_dict, keys, default=None):
    """
    Deep get on python dictionary. Key is in dot notation.
    Returns value if found. Default returned if not found.
    Default can be set to another deep_get function.
    """
    keys=keys.split('.')
    def _reducer(d, key):
        if isinstance(d, dict):
            return d.get(key, default)
        return default
    return reduce(_reducer, keys, _dict)


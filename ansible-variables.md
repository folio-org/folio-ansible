# Variables used in Ansible playbooks and roles

## YAML for variables with default values
```yaml
---
# okapi-src role
okapi_src_home: /opt/okapi-src
okapi_home: /opt/okapi

# docker-server role
docker_users:
  - "{{ ansible_user_id }}"
```

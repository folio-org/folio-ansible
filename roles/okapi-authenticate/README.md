# Okapi Authenticate
This role authenticates to the supertenant in the event that the superuser is secured. okapi-authenticate sets the login token as `supertenant_token`. `supertenant_token` can be used in other roles.

## Calling okapi-authenticate from another role
Include this role before any tasks that make calls to the Okapi supertenant. For example:
```
# Authenticate to supertenant if required
- name: include okapi-authenticate role
  include_role:
    name: okapi-authenticate
  when: supertenant_token is not defined
```
Any calls to the Okapi supertenant must include appropriate headers. It's OK to send headers even when they are not required. For example, include these headers for a call to Okapi that requires an authtoken:
```
headers:
  X-Okapi-Tenant: "supertenant"
  X-Okapi-Token: "{{ supertenant_token | default('') }}"
  Accept: application/json
```
If `supertenant_token` is not defined, an emtpy string will be sent.

## Defaults
```
---
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
superuser_username: super_admin
superuser_password: admin
```


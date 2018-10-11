# okapi-register-modules

Ansible role for registering a set of modules from a variable list, or from one or more JSON install files. The role either pulls in the module descriptors from specific URLs or from a module descriptor registry. In addition, the role can optionally update the `launchDescriptor` property of the module descriptor before posting to Okapi.

## Prerequisites

* A running Okapi system

* A list of modules in the `folio_modules` variable. This list can be set globally in a variables file, or created by another role, such as `build-module-list`

## Usage

Invoke the role in a playbook, e.g.:

```yaml
- hosts: my-folio-test
  roles:
    - role: okapi-register-modules
      folio_modules:
        - name: mod-login # this is the base of the module name
          version: 3.1.0 # if undefined, defaults to "latest"
          # If mod_descriptor_url is defined, it overrides mod_descriptor_repo
          # (both the role-level variable and the item-level variable)
          # mod_descriptor_url: https://cdn.rawgit.com/folio-org/mod-login/v3.1.0/ModuleDescriptor.json
          mod_descriptor_repo: http://folio-registry.aws.indexdata.com
          # the following properties override the embedded launch descriptor in the
          # module descriptor, if it exists
          # override dockerCMD
          docker_cmd:
            - "verify.user=true"
          # override env
          docker_env:
            - { name: JAVA_OPTIONS, value: "-Xmx256m" }
          # override dockerPull, unfortunately for legacy purposes needs to be a string
          # anything other than "true" is false 
          okapi_docker_pull: "true"
```

For legacy reasons, the role puts the variable `folio_modules_withid` into the environment for other roles and tasks to use (it is used by the deprecated `okapi-deploy-modules` role).

## Variables

See above for documentation on the format of the `folio_modules` variable.

```yaml
---
# Defaults
okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"
folio_modules: [ ]
mod_descriptor_repo: http://folio-registry.aws.indexdata.com
update_launch_descr: no
```

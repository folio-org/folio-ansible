# folio-ansible

Copyright (C) 2016 The Open Library Foundation

This software is distributed under the terms of the Apache License,
Version 2.0. See the file "[LICENSE](LICENSE)" for more information.

# Sample Ansible playbook and roles for FOLIO (and Vagrant)

This repository contains some sample Ansible roles for getting a FOLIO
installation up and running quickly. For more details, see the
[ansible-roles](ansible-roles.md) and [vagrant](vagrant.md) files in
this directory.

## Quick Start
`$ vagrant up` will start up a VM with Okapi and the mod-users module
running in Docker containers on the VM. The Okapi port on the VM
(9130) will be forwarded to localhost:9130.

To try other roles, edit [folio.yml](folio.yml) and rebuild the
Vagrant box. A running system requires an Okapi role (either
okapi-docker or okapi-src) underneath whatever modules you select. The
data roles require that the module they relate to be selected.

## Requirements
1. [Ansible](http://docs.ansible.com/ansible/intro_installation.html) \>= 2.1
2. For Vagrant deployment:
  * [Vagrant](https://www.vagrantup.com)
  * [VirtualBox](https://www.virtualbox.org)

This installation has been tested on macOS "Sierra" and Ubuntu 16.04.


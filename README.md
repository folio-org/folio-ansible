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

To test this, fetch a list of users:

	$ curl -w '\n' -H 'X-Okapi-Tenant:diku' -D- http://localhost:9130/users

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

## Additional information

Other FOLIO Developer documentation is at [dev.folio.org](http://dev.folio.org/)

## Troubleshooting

### Recent Vagrant versions have non-working `curl`

Vagrant v1.8.1 is known to work. Later versions may run into problems
-- in particular v1.8.7 on macOS 10.12.1 fails, saying:

	Box 'debian/contrib-jessie64' could not be found. Attempting to find and install

This is because the Vagrant distribution for some reason includes own `curl` binary,
`/opt/vagrant/embedded/bin/curl`, but not a corresponding
`libcurl.4.dylib` library. The version of that library included in the
operating system provides version 7.0.0 but Vagrant's `curl` binary
requires version 9.0.0.

The stupid but successful fix is to use Vagrant 1.8.1, not a later
version.

### Loading users

Sometimes users do not correctly load within the virtual machine. It's
not yet clear why this happens, but it can typically be fixed by
running

	$ vagrant provision

(If necessary, multiple times.)


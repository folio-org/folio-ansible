# folio-ansible

Copyright (C) 2016 The Open Library Foundation

This software is distributed under the terms of the Apache License,
Version 2.0. See the file "[LICENSE](LICENSE)" for more information.

# Sample Ansible playbook and roles for FOLIO (and Vagrant)

This repository contains some sample Ansible roles for getting a FOLIO
installation up and running quickly. For more details, see the
[ansible-roles](ansible-roles.md) and [vagrant](vagrant.md) files in
this directory.

The primary audiences for these playbooks are:

1. Developers who want to take the code for a spin in a VM, without altering their own working environment.
2. DevOps and others interested in automating FOLIO image builds
3. System administrators interested in deployment down the road.

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

## Troubleshooting

### Recent Vagrant versions have non-working `curl`

On macOS at least, there is an issue with the current Vagrant v1.8.7

The Vagrant distribution for some reason includes its own `curl` binary,
`/opt/vagrant/embedded/bin/curl`, but not a corresponding
`libcurl.4.dylib` library. The version of that library included in the
operating system provides version 7.0.0 but Vagrant's `curl` binary
requires version 9.0.0.

The recommended workaround is to remove the 'bin/curl' that comes
with vagrant, and so just let it use the system one (see
[FOLIO-379](https://issues.folio.org/browse/FOLIO-379).

(This is
[a known issue for v1.8.7](https://github.com/mitchellh/vagrant/issues/7969).

### VERR_SVM_DISABLED

Trying to start VirtualBox may fail with the message

> Stderr: VBoxManage: error: AMD-V is disabled in the BIOS (or by the host OS) (VERR_SVM_DISABLED)

This indicates that the BIOS of the host hardware is not configured to
support virtualisation. The only fix is to reboot the host and poke
around in the BIOS settings. The necessary setting should be found in
the CPU Configuration, and will have a name like SVM, Secure Virtual
Machine Mode or AMD-V. Good luck!

### Loading users

Sometimes users do not correctly load within the virtual machine. It's
not yet clear why this happens, but it can typically be fixed by
running

	$ vagrant provision

(If necessary, multiple times.)

## See Also

A ready-built VM is also available: see
[the demo directory](demo/README.md).

## Additional information

Other FOLIO Developer documentation is at [dev.folio.org](http://dev.folio.org/)

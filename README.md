# folio-ansible - Sample Ansible playbook and roles for FOLIO (and Vagrant)

This repository contains some sample Ansible roles for getting a FOLIO
installation up and running quickly. For more details, see the
[doc](doc/index.md) directory.

The primary audiences for this project are:

1. Developers who want to take the code for a spin in a VM, without
   altering their own working environment.
2. Frontend developers looking for a "black box" FOLIO backend system
   to code against.
3. DevOps and others interested in automating FOLIO image builds
4. System administrators interested in deployment down the road.

Copyright (C) 2016 The Open Library Foundation

This software is distributed under the terms of the Apache License,
Version 2.0. See the file "[LICENSE](LICENSE)" for more information.

## System Requirements

For Vagrant deployment:
* [Vagrant](https://www.vagrantup.com)
* [VirtualBox](https://www.virtualbox.org)

For Ansible provisioning (to build a dev VM, or to build the demo or
backend system from scratch)
* [Ansible](http://docs.ansible.com/ansible/intro_installation.html) \>= 2.1

This installation has been tested on macOS "Sierra" and Ubuntu 16.04.

## Quick Start

To run a backend "blackbox" system using Vagrant: `vagrant up backend`
(currently includes Okapi, mod-users, sample tenant "diku", and sample
user data)

To run a demo system using Vagrant: `vagrant up demo`
(currently includes Okapi, mod-users, sample tenant "diku", and sample
user data - exactly like the backend system, at the moment)

To build a development environment using Vagrant: `vagrant up dev`
* Requires Ansible \>= 2.1
(currently includes Okapi and mod-users running in Docker containers,
sample tenant "diku", and sample user data with source code shared in
the working directory)

For all Vagrant boxes, the Okapi port on the VM (9130) will be
forwarded to localhost:9130.

To test this, fetch a list of users:

	$ curl -w '\n' -H 'X-Okapi-Tenant:diku' -D- http://localhost:9130/users

To try other roles, edit [folio.yml](folio.yml) and rebuild the
"dev" Vagrant box. A running system requires an Okapi role (okapi-demo,
okapi-docker, or okapi-src) underneath whatever modules you select. The
data roles require that the module they relate to be selected.

## Documentation

* [VM and playbook documentation](doc/index.md)
* [Contributing guidelines](CONTRIBUTING.md)
* [Vagrant documentation](https://www.vagrantup.com/docs/)
* [Ansible documentation](http://docs.ansible.com/ansible/index.html)
* Other FOLIO Developer documentation is at [dev.folio.org](http://dev.folio.org/)

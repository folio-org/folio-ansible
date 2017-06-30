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

## License

Copyright (C) 2017 The Open Library Foundation

This software is distributed under the terms of the Apache License,
Version 2.0. See the file "[LICENSE](LICENSE)" for more information.

## System Requirements

For Vagrant deployment:
* [Vagrant](https://www.vagrantup.com); for Windows use 1.9.2 or \>= 1.9.4.
* [VirtualBox](https://www.virtualbox.org)

For Ansible provisioning (to build a dev VM, or to build the demo or
backend system from scratch)
* [Ansible](http://docs.ansible.com/ansible/intro_installation.html) \>= 2.2

This installation has been tested on macOS "Sierra", Ubuntu 16.04, and
Windows 10. Note that Windows cannot serve as an Ansible control host.

## Quick Start

If all you want to do is try out a prepackaged FOLIO demo Vagrant box,
create a new directory, `cd` into it, and try:

    $ vagrant init folio/stable
    $ vagrant up

There are also `folio/testing` and `folio/testing-backend` Vagrant boxes available,
which contain the most recent versions of all components, absolutely
_not_ guaranteed to work together. The Vagrant Cloud page for
[folio/stable](https://app.vagrantup.com/folio/boxes/stable) has
detailed release notes, including which versions of the backend and
frontend modules are provided.

For all Vagrant boxes, the Okapi port on the VM (9130) will be
forwarded to `localhost:9130` and the Stripes port and user interface
will be forwarded to `localhost:3000`. You should see the Stripes user
interface at `http://localhost:3000`.

For more information, see [Vagrant VMs and Ansible roles](doc/index.md).

In addition, this project includes a [Vagrantfile](Vagrantfile) for
creating different environments.

## Documentation

* [VM and playbook documentation](doc/index.md)
* [Contributing guidelines](CONTRIBUTING.md)
* [Vagrant documentation](https://www.vagrantup.com/docs/)
* [Ansible documentation](http://docs.ansible.com/ansible/index.html)
* See project [FOLIO](https://issues.folio.org/browse/FOLIO)
at the [FOLIO issue tracker](http://dev.folio.org/community/guide-issues)
* Other FOLIO Developer documentation is at [dev.folio.org](http://dev.folio.org/)

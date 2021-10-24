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

Copyright (C) 2016-2021 The Open Library Foundation

This software is distributed under the terms of the Apache License,
Version 2.0. See the file "[LICENSE](LICENSE)" for more information.

## System Requirements

For Vagrant deployment:
* [Vagrant](https://www.vagrantup.com) \>= 1.9.6 (note that Ubuntu
  provides a
  [broken 2.0.2 version](https://github.com/hashicorp/vagrant/issues/9788)
  and an outdated 1.9.1 version, install the latest
  [Debian file from the Vagrant Download page](https://www.vagrantup.com/downloads.html)
  using `dpkg -i vagrant\_….deb` instead)
* [VirtualBox](https://www.virtualbox.org)

For Ansible provisioning (to build a dev VM, or to build the demo or
backend system from scratch)
* [Ansible](http://docs.ansible.com/ansible/intro_installation.html) \>= 2.3

This installation has been tested on macOS "Sierra", Ubuntu 16.04 and 18.04, and
Windows 10. Note that Windows cannot serve as an Ansible control host.

## Quick Start

If all you want to do is try out a prepackaged FOLIO demo Vagrant box,
create a new directory, `cd` into it, and try:

    $ vagrant init folio/release-core
    $ vagrant up

Now you can open [http://localhost:3000](http://localhost:3000).
Admin login: diku\_admin/admin

Or, if you want to try a prepackaged FOLIO backend Vagrant box with the
most recent versions of all components, try:

    $ vagrant init folio/testing-backend
    $ vagrant up

The testing boxes are absolutely _not_ guaranteed to work together.

The Vagrant Cloud page [folio](https://app.vagrantup.com/folio) lists
all available boxes and has
detailed release notes, including which versions of the backend and
frontend modules are provided.

For all Vagrant boxes, the Okapi port on the VM (9130) will be
forwarded to `localhost:9130` and the Stripes port and user interface
will be forwarded to `localhost:3000`. You should see the Stripes user
interface at `http://localhost:3000`.

For more information, see [Vagrant VMs and Ansible roles](doc/index.md).

In addition, this project includes a [Vagrantfile](Vagrantfile) for
creating different environments.

## Deployment on a server or virtual machine

### Deploy host requirement

The deploy host is used to run the Ansible playbooks.

* Linux or MacOSX
* Ansible installed
* ssh configured to access the server - preferred using ssh-keys

### Server requirements

* Ubuntu 16.04 for Folio Fameflower
* Ubuntu 20.04 or Debian 10 for Folio Honeysuckle
* Python installed
* For SSL you need
    * Certificate file and a key file without Password
    * FQDN

### Installation

To install Folio using the folio.yml Ansible playbook, you have to download
and unpack the folio-ansible sources. Then create a inventory file.
You also have to configure some parameters. You can put
these in the inventory file, in group vars files or in host vars files. In this
example we use the inventory. The contents of the inventory file `inventory.yml`:

    all:
      hosts:
        my-host.domain.com:
      children:
        release:
          hosts:
            my-host.domain.com:
              save_dir: /etc/folio/savedir
              okapi_interface: ens3
              okapi_storage: postgres
              tenant: mytenant
              tenant_name: "My Organisation"
              tenant_description: "Description of my Organisation"
              okapi_role: dev
        stripes:
          hosts:
            my-host.domain.com:
              stripes_host_address: 0.0.0.0
              stripes_okapi_url: http://my-host.domain.com:9130
              stripes_tenant: mytenant

Next we can install Folio using the `folio.yml` playbook:

    ansible-playbook -u ubuntu -i inventory.yml folio.yml

To learn more about the parameters, you should have a look at the
playbook `folio.yml`, to see which roles are executed and in the
documentation of the roles.

Another example includes deployment of Stripes to use https instead of http,
securing okapis supertenant and the tenant admin user.

    all:
      hosts:
        my-host.domain.com:
      children:
        release:
          hosts:
            my-host.domain.com:
              save_dir: /etc/folio/savedir
              okapi_interface: ens3
              okapi_storage: postgres
              tenant: mytenant
              tenant_name: "My Organisation"
              tenant_description: "Description of my Organisation"
              okapi_role: dev
              admin_user:
                username: my_admin
                password: tenantadminpassword
        stripes:
          hosts:
            my-host.domain.com:
              stripes_host_address: 0.0.0.0
              stripes_okapi_url: http://my-host.domain.com:9130
              stripes_tenant: mytenant
              stripes_enable_https: yes
              stripes_certificate_file: /path/to/certificate.pem
              stripes_certificate_key_file: /path/to/key.pem
              nginx_proxy_okapi: yes
              stripes_listen_port: 443
              stripes_server_name: my-host.domain.com
        production:
          hosts:
            my-host.domain.com:
              superuser_username: opkapi_superuser
              superuser_password: superpassword



## Documentation

* [VM and playbook documentation](doc/index.md)
* [Contributing guidelines](CONTRIBUTING.md)
* [Vagrant documentation](https://www.vagrantup.com/docs/)
* [Ansible documentation](http://docs.ansible.com/ansible/index.html)
* See project [FOLIO](https://issues.folio.org/browse/FOLIO)
at the [FOLIO issue tracker](https://dev.folio.org/guidelines/issue-tracker).
* Other FOLIO Developer documentation is at [dev.folio.org](https://dev.folio.org/)

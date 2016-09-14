# Build a working development FOLIO installation from source

This repository contains a sample Vagrantfile and Ansible playbook and
roles to build a development environment for FOLIO. The Vagrantfile
creates a VirtualBox VM based on the
"[debian/contrib-jessie64](https://atlas.hashicorp.com/debian/boxes/contrib-jessie64)"
image on Atlas (for shared folder support). The root of the project
directory is shared with the VM at the /vagrant mountpoint. In
addition, the default Okapi port (9130) is forwarded to the localhost.

The Vagrant box is placed in the Ansible "dev" group, so the Ansible
roles, variables, and plays that apply to that group are used to
provision the box.

The roles that are provisioned on the Vagrant box are:
* okapi-src: The folio-org/okapi GitHub repository is cloned into the
  working directory as "okapi-src" (/vagrant/okapi-src on the Vagrant
  box). It is built using Maven, and linked into the more canonical
  Okapi home directory (/opt/okapi), then launched.

* okapi-test: The test modules from okapi-src are deployed to the
  running Okapi instance.


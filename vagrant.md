# Build a working development FOLIO installation from source

This repository contains a sample Vagrantfile, an Ansible playbook
and roles to build a development environment for FOLIO. The
Vagrantfile creates a VirtualBox VM based on the
"[debian/contrib-jessie64](https://atlas.hashicorp.com/debian/boxes/contrib-jessie64)"
image on Atlas (for shared folder support). The root of the project
directory is shared with the VM at the /vagrant mountpoint. In
addition, the default Okapi port (9130) is forwarded to the localhost.

In the default [Vagrantfile](Vagrantfile), the Vagrant box is placed
in the Ansible "dev" group, so the Ansible roles, variables, and plays
that apply to that group are used to provision the box.

The roles that are provisioned on the Vagrant dev box are:
* okapi-src: The folio-org/okapi GitHub repository is cloned into the
  working directory as "okapi-src" (/vagrant/okapi-src on the Vagrant
  box). It is built using Maven, and linked into the more canonical
  Okapi home directory (/opt/okapi), then launched.

* okapi-test: The test modules from okapi-src are deployed to the
  running Okapi instance.

* mod-auth-src: The mod-auth module is deployed with sample data and
  tests.

If you set the environment variable "FOLIO_DEPLOY" to "docker", you
will get a Docker-based installation instead. This puts the Vagrant
box in the Ansible "docker" group, so the Ansible roles, variables,
and plays that apply to that group are used to provision the box.

The roles that are provisioned on the Vagrant docker box are:
* docker-engine: The Vagrant box is configured as a Docker server.

* okapi-docker: The folio-org/okapi GitHub repository is cloned into the
  working directory as "okapi-src" (/vagrant/okapi-src on the Vagrant
  box). A Docker image is created and launched.

* mod-circulation-docker: The folio-org/mod-circulation GitHub
  repository is cloned into the working directory as
  "mod-circulation-src" (/vagrant/mod-circulation-src on the Vagrant
  box. The source is built and a Docker image is created to run the
  JAR. A container is launched through Okapi and some test data is
  loaded.

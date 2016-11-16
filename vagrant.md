# Build a working development FOLIO installation from source

This repository contains a sample Vagrantfile, an Ansible playbook
and roles to build a development environment for FOLIO. The
Vagrantfile creates a VirtualBox VM based on the
"[debian/contrib-jessie64](https://atlas.hashicorp.com/debian/boxes/contrib-jessie64)"
image on Atlas (for shared folder support). The root of the project
directory is shared with the VM at the /vagrant mountpoint. In
addition, the default Okapi port (9130) is forwarded to the localhost.

The default [Vagrantfile](Vagrantfile) has definitions for two VMs,
"dev" and "demo". Only the "dev" VM is started by default. Both VMs
use the [folio.yml](folio.yml) file to control provisioning. You can
edit folio.yml to pick and choose different roles - see the
[ansible-roles](ansible-roles.md) documentation for more details.

The primary purpose of the "demo" VM is to provide a basis for a
prebuilt FOLIO Vagrant box, so it may not meet the needs of coders
interested in a deep dive into the code.

The "dev" VM bridges the Okapi server to port 9130 on the host
machine. The "demo" VM bridges Okapi to port 9131.

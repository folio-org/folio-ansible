# The folio-ansible "black box"

The main folio-ansible project, in
[the parent directory](../README.md),
creates a virgin Debian Jessie box, then builds and installs FOLIO
components such as Okapi and mod-users. This process can be slow.

As an alternative, this area creates and deploys a ready-to-go "black
box" with all the relevant FOLIO components already installed and
running. Just run

	$ vagrant up

The running Okapi is made available on port 9130.

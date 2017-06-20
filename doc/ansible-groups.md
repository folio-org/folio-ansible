# Ansible groups for folio-ansible

The folio-ansible project refers to a few different Ansible inventory
groups in the folio.yml file and in the group_vars directory:

## In folio.yml
* folio-backend: for hosts on which you are building a backend FOLIO
  system, including Okapi, storage modules, and business-logic
  modules.

* stripes: for hosts on which you want to build and run a Stripes
  webpack server

## In group_vars
* stable: a set of variable definitions for building a stable FOLIO
  system out of released components

* testing: a set of variable definitions for building a FOLIO system
  out of the most recent commits to the code

* vagrant: a few variable definitions for building the folio/stable
  and folio/testing vagrant boxes

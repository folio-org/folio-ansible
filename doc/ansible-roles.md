# Ansible roles in this repository

The [main playbook](../folio.yml) and [Vagrantfile](../Vagrantfile) in
this repository are targeted to build FOLIO systems using Ansible
against an Ubuntu 16.04 (Xenial) host. The Ansible inventory
is designed to support a few groups as follows:

* `folio` -- targets hosts for building a full FOLIO system
* `vagrant` -- targets hosts built as stand-alone Vagrant systems
* `testing` -- targets hosts that run a FOLIO installation based on
  the HEAD of the master branch of the FOLIO component modules

There are Ansible variables files in the `group_vars` directory with
settings for the `vagrant`, and `testing` groups.

The folio.yml playbook uses the following roles:

*All roles targeted for Ubuntu 16.04 (Xenial)*

## ansible
Installs Ansible from the Ansible repository

## common
Runs `apt-cache update`, creates the folio user and group, installs
git, curl, and the postgresql client from apt. Configures the FOLIO
apt repository.

## docker-engine
Installs the Docker engine from the Docker repository.

## maven-3
Installs Apache Maven 3 from the Apache archive.

## mod-auth-data
Hooks up mod-auth modules for the sample tenant, loads sample users
and auth data. Depends on tenant-data.

*Note: without a running Okapi instance with mod-auth and mod-users,
 this role will fail*

## mod-auth-demo-users
Creates shim users in mod-auth login and permissions modules for all
users in mod-users (with password = username), if they don't already
exist in the mod-auth modules. Temporary fix until there is a business
logic module that handles both users and authn/z. Depends on
mod-auth-data.

*Note: without a running Okapi instance with mod-auth and mod-users,
 this role will fail*

## mod-circulation-data
Sample data for the mod-circulation business logic module. Depends on:
- tenant-data
- mod-users-data

*Note: without a running Okapi instance with mod-circulation and
 mod-loan-storage installed and enabled, this role will fail.*

## mod-configuration-data
Hooks up mod-configuration for the sample tenant. Depends on
tenant-data.

*Note: without a running Okapi instance, this role will fail*

## mod-users-bl-data
Sample data for the mod-users-bl business logic module. Depends on:
- tenant-data
- mod-users-data

*Note: without a running Okapi instance with mod-users-bl and
 mod-users installed and enabled, this role will fail.*

## mod-users-data
Sample data for the mod-users backend module. Depends on
tenant-data. If mod-auth modules are enabled, must run _after_
mod-auth-data role, or permissions will not be correctly initialized.

*Note: without a running Okapi instance with mod-users installed and
enabled, this role will fail.*

## mongodb-org
Installs a more recent MongoDB Community Edition from the Mongo
repository.

## nodejs
Installs nodejs, n, and mocha

## postgresql
Installs a more recent PostgreSQL from the PostgreSQL repository.

## okapi
Installs Okapi from apt as a system service with persistent
storage. Depends on openjdk-8 and postgresql.

## okapi-deploy-modules
Installs an okapi-deploy service on the target, configured by the
`folio_modules` variable. See
[../group_vars/blackbox](../group_vars/blackbox) for a working set of
module defaults. The service posts deployment descriptors to a running
Okapi instance.

*Note: This role depends on a running Okapi instance. Modules defined
 in the `folio_modules` variable must be registered with Okapi (see
 okapi-register-modules role below).*

## okapi-register-modules
Posts module descriptors to a running Okapi, configured by the
`folio_modules` variable. See
[../group_vars/blackbox](../group_vars/blackbox) for a working set of
module defaults.

*Note: This role depends on a running Okapi instance.*

## okapi-src
Clones the folio-org/okapi repository from GitHub, builds the JAR
files needed for deployment. Depends on common, openjdk-8, and
maven-3. Launches an Okapi server in development mode from the source
tree.

## okapi-test
Deploys the Okapi test modules from the source code in the
folio-org/okapi repository. Depends on okapi-src.

## okapi-undeploy
Installs a simple script to undeploy all instances of a module from a
running Okapi.

## openjdk-8
Installs the openjdk-8-jdk package from backports, required for Okapi
and Maven 3.

## sdkman
Installs SDKMAN! from http://sdkman.io
Depends on common

## stripes-docker
Builds a Docker container with Stripes and the configured modules from
the
[folioci npm respository](https://repository.folio.org). Optionally
creates a container to proxy Stripes using nginx.

*Note: requires a running Okapi with a configured tenant and
 appropriate backend modules*

## raml-module-builder
Clones the folio-org/raml-module-builder repository from GitHub,
builds the code. Depends on openjdk-8 and maven-3.

## tenant-data
Load a demo tenant into a running Okapi instance.

## yarn
Installs the [yarn package manager](https://yarnpkg.com) from the yarn
repository. Depends on nodejs.

## mod-auth-src (*Deprecated*)
Clones the folio-org/mod-auth repository from GitHub, builds and
deploys the modules. Depends on:
- common
- openjdk-8
- maven-3
- mongodb-org
- okapi-undeploy

*Note: without a running Okapi instance, this role will fail.*

## mod-auth (*Deprecated*)
Loads the Docker images for the authtoken, login, and permissions
modules from Docker Hub, registers and deploys as a system service in
a running Okapi instance, with persistent storage. Depends on:
- postgresql
- docker-engine
- okapi-undeploy

*Note: without a running Okapi instance, this role will fail.*

## mod-auth-demo (*Deprecated*)
Hooks up mod-auth with mod-users, loads sample permissions data for
the sample tenant (diku). Depends on mod-auth, mod-users-demo,
tenant-data.

## mod-auth-sample (*Deprecated*)
Build and deploy the mod-auth Node.js sample modules (thing-module and
retrieve-module). Depends on mod-auth and nodejs.

*Note: without a running Okapi instance, this role will fail.*

## mod-circulation (*Deprecated*)
Loads the Docker image from Docker Hub, registers and deploys as a
system service in a running Okapi instance. Depends on:
- docker-engine
- okapi-undeploy

*Note: without a running Okapi instance with mod-loan-storage, this
 role will fail*

## mod-circulation-build (*Deprecated*)
Clones and builds the source from folio-org/mod-circulation on
GitHub. Depends on common, openjdk-8, and maven-3.

## mod-circulation-docker (*Deprecated*)
Builds the Docker image for mod-circulation and launches it via
Okapi. Depends on mod-circulation-build, docker-engine, and
okapi-docker or okapi-src.

## mod-loan-storage (*Deprecated*)
Loads the Docker image from Docker Hub, registers and deploys as a
system service in a running Okapi instance, with persistent
storage. Depends on:
- postgresql
- docker-engine
- okapi-undeploy

## mod-metadata (*Deprecated*)
Loads the Docker images for the inventory-storage and inventory
modules from Docker Hub, registers and deploys as a system service in
a running Okapi instance, with persistent storage. Depends on:
- postgresql
- docker-engine
- okapi-undeploy

*Note: without a running Okapi instance, this role will fail.*

## mod-metadata-build (*Deprecated*)
Clones and builds the source from folio-org/mod-metadata on
GitHub. Depends on:
- common
- openjdk-8
- maven-3

## mod-metadata-demo (*Deprecated*)
Registers and deploys mod-metadata modules with persistent storage in
a running Okapi instance. Depends on:
- mod-metadata-build
- postgresql
- okapi-undeploy

*Note: without a running Okapi instance, this role will fail.*

## mod-users (*Deprecated*)
Loads the Docker image from Docker Hub, registers and deploys as a
system service in a running Okapi instance, with persistent
storage. Depends on:
- postgresql
- docker-engine
- okapi-undeploy

*Note: without a running Okapi instance, this role will fail.*

## mod-users-bl (*Deprecated*)
Loads the Docker image from Docker Hub, registers and deploys as a
system service in a running Okapi instance. Depends on:
- docker-engine
- okapi-undeploy

*Note: without a running Okapi instance with mod-users, this
 role will fail*

## mod-users-build (*Deprecated*)
Clones and builds the source from folio-org/mod-users on
GitHub. Depends on common, openjdk-8, and maven-3.

## mod-users-demo (*Deprecated*)
Registers and deploys mod-users with persistent storage in a running
Okapi instance. Depends on:
- mod-users-build
- postgresql
- okapi-undeploy

*Note: without a running Okapi instance, this role will fail.*

## mod-users-docker (*Deprecated*)
Builds a Docker image from the Dockerfile and registers it with
Okapi. Depends on docker-engine, mod-users-build.

## okapi-demo (*Deprecated*)
Clones the folio-org/okapi repository from GitHub, installs and
launches Okapi as a system service with persistent storage. Depends on
common, openjdk-8, maven-3, and postgresql.

## okapi-docker (*Deprecated*)
Clones the folio-org/okapi repository from GitHub, builds and launches
an Okapi server in development mode in a Docker container. Depends on
docker-engine.

## stripes (*Deprecated*)
Installs stripes from the
[folioci npm repository](https://repository.folio.org). Launches the
stripes dev server as a system service. Depends on yarn. Includes the
following Stripes modules:
- trivial
- ui-items
- ui-okapi-console
- ui-users

*Note: requires a running Okapi with a configured tenant, mod-users,
 and mod-metadata Sample data available in mod-users-data*

## stripes-core (*Deprecated*)
Installs stripes from the
[folioci npm repository](https://repository.folio.org). Launches the
stripes dev server with the Okapi Console as a system service. Depends
on yarn.

*Note: without a running Okapi instance and a configured tenant, the
 Okapi Console will not run*

## ui-items (*Deprecated*)
Adds the ui-items module to stripes-core from
https://repository.folio.org/repository/npm-folioci/
Depends on stripes-core.

*Note: without a running Okapi instance and a configured tenant, the
 Items application will not run.*

## ui-okapi-console (*Deprecated*)
Adds the ui-okapi-console module to stripes-core from
https://repository.folio.org/repository/npm-folioci/
Depends on stripes-core.

*Note: without a running Okapi instance, this role will fail.*

## ui-users (*Deprecated*)
Adds the ui-users module to stripes-core from
https://repository.folio.org/repository/npm-folioci/
Depends on stripes-core.

*Note: without a running Okapi instance and a configured tenant, the
 Users application will not run. Sample user data is available in
 mod-users-data.*

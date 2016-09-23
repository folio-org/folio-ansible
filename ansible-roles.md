# Ansible roles in this repository

*All roles targeted for Debian 8 (Jessie)*

## common
Currently just runs `apt-cache update`

## openjdk-8
Installs the openjdk-8-jdk package from backports, required for Okapi
and Maven 3.

## maven-3
Installs Apache Maven 3 from the Apache archive.

## okapi-src
Clones the folio-org/okapi repository from GitHub, builds and launches
an Okapi server in development mode from the source tree. Depends on
common, openjdk-8, and maven-3.

## okapi-test
Deploys the Okapi test modules from the source code in the
folio-org/okapi repository. Depends on okapi-src.

## mod-auth-src
Clones the folio-org/mod-auth repository from GitHub, builds and
deploys the modules. Depends on okapi-src.

## raml-module-builder
Clones the folio-org/raml-module-builder repository from GitHub,
builds the code. Depends on openjdk-8 and maven-3. Not strictly
necessary for module development.

## docker-engine
Installs the Docker engine from the Docker repository. Not strictly
necessary for module development.


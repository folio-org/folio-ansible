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
an Okapi server in development mode from the source tree.

## okapi-test
Deploys the Okapi test modules from the source code in the
folio-org/okapi repository.

## docker-engine
Installs the Docker engine from the Docker repository.


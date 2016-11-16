# Ansible roles in this repository

*All roles targeted for Debian 8 (Jessie)*

## common
Currently just runs `apt-cache update`

## docker-engine
Installs the Docker engine from the Docker repository. Not strictly
necessary for module development.

## openjdk-8
Installs the openjdk-8-jdk package from backports, required for Okapi
and Maven 3.

## maven-3
Installs Apache Maven 3 from the Apache archive.

## okapi-demo
Clones the folio-org/okapi repository from GitHub, installs and
launches Okapi as a system service with persistent storage. Depends on
common, openjdk-8-jdk, maven-3, and mongodb-org.

## okapi-docker
Clones the folio-org/okapi repository from GitHub, builds and launches
an Okapi server in development mode in a Docker container. Depends on
docker-engine.

## okapi-src
Clones the folio-org/okapi repository from GitHub, builds the JAR
files needed for deployment. Depends on common, openjdk-8, and
maven-3. Launches an Okapi server in development mode from the source
tree.

## okapi-test
Deploys the Okapi test modules from the source code in the
folio-org/okapi repository. Depends on okapi-src.

## mod-auth-src
Clones the folio-org/mod-auth repository from GitHub, builds and
deploys the modules. Depends on mongodb-org and okapi-src.

## mod-circulation-build
Clones and builds the source from folio-org/mod-circulation on
GitHub. Depends on common, openjdk-8-jdk, and maven-3.

## mod-circulation-docker
Builds the Docker image for mod-circulation and launches it via
Okapi. Depends on mod-circulation-build, docker-engine, and
okapi-docker or okapi-src.

## mod-users-build
Clones and builds the source from folio-org/mod-users on
GitHub. Depends on common, openjdk-8-jdk, and maven-3.

## mod-users-demo
Installs and launches mod-users with persistent storage in a running
Okapi instance. Depends on mod-users-build and mongodb-org.
*Note: without a running Okapi instance, this role will fail*

## mod-users-docker
Builds a Docker image from the Dockerfile and registers it with
Okapi. Depends on docker-engine, mod-users-build.

## mod-circulation-docker
Builds the Docker image for mod-circulation and launches it via
Okapi. Depends on mod-circulation-build, docker-engine, and
okapi-docker or okapi-src.

## mongodb-org
Installs a more recent MongoDB Community Edition from the Mongo
repository.

## raml-module-builder
Clones the folio-org/raml-module-builder repository from GitHub,
builds the code. Depends on openjdk-8 and maven-3.

## tenant-data
Load a demo tenant into a running Okapi instance

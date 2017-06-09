# folio-ansible - Vagrant VMs and Ansible Roles

<!-- ../../okapi/doc/md2toc -l 2 index.md -->
* [Prebuilt Vagrant boxes](#prebuilt-vagrant-boxes)
* [FOLIO system setup on Vagrant boxes](#folio-system-setup-on-vagrant-boxes)
* [Replace localhost by hostname on the demo box](#replace-localhost-by-hostname-on-the-demo-box)
* [Updating FOLIO components on Vagrant boxes](#updating-folio-components-on-vagrant-boxes)
    * [Updating Okapi](#updating-okapi)
    * [Updating Docker-based modules](#updating-docker-based-modules)
    * [Updating Stripes](#updating-stripes)
* [Vagrantfile targets](#vagrantfile-targets)
* [Troubleshooting/Known Issues](#troubleshootingknown-issues)
    * [Vagrant "forwarded port to 9130 is already in use"](#vagrant-forwarded-port-to-9130-is-already-in-use)
    * [Viewing the Okapi log](#viewing-the-okapi-log)
    * [Viewing backend module logs](#viewing-backend-module-logs)
    * [Viewing the Stripes log](#viewing-the-stripes-log)
    * [Some recent Vagrant versions have non-working `curl`](#some-recent-vagrant-versions-have-non-working-curl)
    * [VERR_SVM_DISABLED](#verrsvmdisabled)
* [Additional information](#additional-information)

## Prebuilt Vagrant boxes

The Vagrantfile and Ansible playbooks and roles in this project are
used to generate prebuilt Vagrant boxes, available on
[Hashicorp Atlas](https://atlas.hashicorp.com/folio):

* [folio/stable](https://atlas.hashicorp.com/folio/boxes/stable) -- a
  full-stack FOLIO system with stable releases of front- and
  backend modules. All components should interoperate correctly.

* [folio/testing](https://atlas.hashicorp.com/folio/boxes/testing) --
  a full-stack FOLIO system, with the very latest releases of front- and
  backend modules. Absolutely _not_ guaranteed to interoperate correctly.

* [folio/curriculum](https://atlas.hashicorp.com/folio/boxes/curriculum)
  -- a box built to support the
  [FOLIO Developer Curriculum](https://github.com/folio-org/curriculum),
  with prerequisites installed.

* [folio/folio-backend](https://atlas.hashicorp.com/folio/boxes/folio-backend)
  -- a backend FOLIO system, with Okapi, mod-users, the mod-metadata
  modules, mod-loan-storage, and mod-circulation. *This box is no
  longer maintained.*

* [folio/folio-demo](https://atlas.hashicorp.com/folio/boxes/folio-demo)
  -- a full-stack FOLIO system, with Okapi, mod-users, mod-metadata,
  mod-loan-storage, mod-circulation, mod-auth, mod-users-bl,
  Stripes, and the Stripes modules trivial, ui-scan, ui-users, and
  ui-items. *This box is no longer maintained.*

* [folio/folio-backend-auth](https://atlas.hashicorp.com/folio/boxes/folio-backend-auth)
  -- a backend FOLIO system with the mod-auth authentication
  subsystem, with Okapi, mod-users, mod-metadata, mod-loan-storage,
  mod-circulation, mod-users-bl, and the mod-auth modules. The authorization
  subsystem includes three sample users, `diku_admin` (password
  "admin"), `auth_test1` (password "diku"), and `auth_test2` (password
  "diku"). *This box is no longer maintained.*

All Vagrant boxes come with sample user and inventory data. The
modules are enabled for the sample tenant, "diku".

To try out any of these boxes, create an empty directory, `cd` into
it, and initialize a Vagrantfile, e.g.:

    $ vagrant init --minimal folio/stable

If you have downloaded a previous version of the box, you will also
need to update it with `vagrant box update`. Then you can launch the
Vagrant box with `vagrant up`. Okapi will be listening on localhost
port 9130, and the Stripes development server will be on localhost
port 3000 (on the demo box only).

## FOLIO system setup on Vagrant boxes

The prebuilt Vagrant boxes have the FOLIO stack set up to mimic
production. Okapi is installed using a Debian installation package,
with its home directory in `/usr/share/folio/okapi`, configuration
files in `/etc/folio/okapi`, and logs in `/var/log/folio/okapi`. The
backend modules are deployed through Okapi using its Docker deployment
facility. The `okapi-deploy` systemd service unit is used to manage
starting and stopping backend modules. Modules are installed following
the convention of configuration in `/etc/folio` and static files in
`/usr/share/folio`. Stripes is installed as a Docker container
configured to restart on reboot.

Data is persisted for all modules using a PostgreSQL server running on
the Vagrant box. The Docker engine is also installed, and configured
to listen on localhost:4243 of the Vagrant box so that Okapi can use
it for module deployment.

## Replace localhost by hostname on the demo box

To make the demo box accessible from other machines than the local one
Stripes needs the hostname of the backend. Configure the hostname
this way:

    $ vagrant init folio/stable
    $ vagrant up
    $ vagrant ssh -c "sudo pico /etc/folio/stripes/stripes.config.js"
      # now replace localhost by your hostname
    $ vagrant ssh -c "sudo systemctl restart stripes.service"

## Updating FOLIO components on Vagrant boxes

All FOLIO components on the prebuilt Vagrant box come from artifacts
created by the FOLIO CI process. That means that whenever a commit to
the master branch of the source repository passes unit tests, a new
artifact is made available. This makes it very easy to update.

*WARNING*: just because it is easy to update does not mean it is
necessarily a good idea. The versions of the various components on the
prebuilt boxes are known to work together. Updating any of them may
well introduce breaking changes that will cause your FOLIO system to
stop working.

### Updating Okapi

    $ sudo systemctl stop okapi-deploy
    $ sudo apt-get update
    $ sudo apt-get install okapi
    $ sudo systemctl start okapi-deploy

### Updating Docker-based modules

    # for a list of images
    $ docker images

    # to update a module, edit its deployment descriptor and update
    # the version specified e.g.:
    $ sudo vi /etc/folio/deployment-descriptors/mod-users.json

    # to undeploy and redeploy using the new image
    $ sudo systemctl restart okapi-deploy

### Updating Stripes

To update Stripes or any Stripes components, update the Stripes
`package.json` file at `/etc/folio/stripes/package.json`, changing the
version of the component in the `dependencies`. Then rebuild the
Docker container and restart it:

    $ docker stop stripes_stripes_1
    $ docker rm stripes_stripes_1
    $ docker rmi stripes
    $ sudo docker build -t stripes:latest /etc/folio/stripes
    $ docker run -d --name stripes_stripes_1 --network stripes-net \
      --network-alias stripes-serv --restart=always \
      -p=0.0.0.0:3000:3000 -e STRIPES_HOST=0.0.0.0 stripes

## Vagrantfile targets

The Vagrantfile in this project contains six target definitions:

1. `stable` -- This target pulls the folio/stable Vagrant box hosted
   on Atlas.
2. `testing` -- This target pulls the folio/testing
   Vagrant box hosted on Atlas.
3. `curriculum` -- This target pulls the folio/curriculum Vagrant box
   hosted on Atlas.
4. `build_stable` -- a target to build the `stable` box for packaging.
5. `build_testing` -- a target to build the `testing` box
   for packaging.
6. `build_curriculum` -- a target to build the `curriculum` box for
   packaging.

## Troubleshooting/Known Issues

### Vagrant "forwarded port to 9130 is already in use"

All the Vagrant boxes defined in the Vagrantfile forward port 9130
(Okapi) on the guest VM to port 9130 on the host. To change the port
forwarding so that you can run multiple boxes at the same time, edit
the Vagrantfile in the root directory of the project.

### Viewing the Okapi log

The Okapi logfile is at `/var/log/folio/okapi/okapi.log`.

### Viewing backend module logs

Backend modules on the prebuilt boxes are deployed by Okapi as Docker
containers. To view the logs:

1. Log into the box using `vagrant ssh`.
2. Get the container name of the module you want to check with `docker ps`.
3. Look at the log with `docker logs <container_name>`. You can
   follow the log by adding the `--follow` parameter to the `docker
   logs` command.

### Viewing the Stripes log

Stripes is deployed as a Docker container.  You can
view the log by logging into the box with `vagrant ssh`, then:

    $ docker logs stripes_stripes_1

To follow the log:

    $ docker logs stripes_stripes_1 --follow

### Launching Vagrant on Windows

If launching Vagrant from a Windows Command Prompt, be sure to use _Run As Administrator..._
when opening the Command Prompt itself (cmd.exe).
If you are seeing the error _"EPROTO: protocol error, symlink"_, the likely cause is that
Vagrant was not launched with administrator privileges.
See issue [STRIPES-344](https://issues.folio.org/browse/STRIPES-344) for details.

### Some recent Vagrant versions have non-working `curl`

On macOS at least, there is an issue with Vagrant v1.8.7

The Vagrant distribution for some reason includes its own `curl` binary,
`/opt/vagrant/embedded/bin/curl`, but not a corresponding
`libcurl.4.dylib` library. The version of that library included in the
operating system provides version 7.0.0 but Vagrant's `curl` binary
requires version 9.0.0.

The recommended workaround is to remove the 'bin/curl' that comes
with vagrant, and so just let it use the system one (see
[FOLIO-379](https://issues.folio.org/browse/FOLIO-379)).

(This is
[a known issue for v1.8.7](https://github.com/mitchellh/vagrant/issues/7969),
fixed in v1.9.0).

### VERR_SVM_DISABLED

Trying to start VirtualBox may fail with the message:

> Stderr: VBoxManage: error: AMD-V is disabled in the BIOS (or by the host OS) (VERR_SVM_DISABLED)

This indicates that the BIOS of the host hardware is not configured to
support virtualization. The only fix is to reboot the host and poke
around in the BIOS settings. The necessary setting should be found in
the CPU Configuration, and will have a name like SVM, Secure Virtual
Machine Mode or AMD-V. Good luck!

## Additional information

* [Ansible roles](ansible-roles.md) and
  [Ansible variables](ansible-variables.md) used in this project
* [Vagrant documentation](https://www.vagrantup.com/docs/)
* [Ansible documentation](http://docs.ansible.com/ansible/index.html)
* [Docker documentation](https://docs.docker.com/)
* Other FOLIO Developer documentation is at [dev.folio.org](http://dev.folio.org/)

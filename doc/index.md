# folio-ansible - Vagrant VMs and Ansible Roles

<!-- ../../okapi/doc/md2toc -l 2 index.md -->
* [Prebuilt Vagrant boxes](#prebuilt-vagrant-boxes)
* [FOLIO system setup on Vagrant boxes](#folio-system-setup-on-vagrant-boxes)
* [Updating FOLIO components on Vagrant boxes](#updating-folio-components-on-vagrant-boxes)
    * [Updating Okapi](#updating-okapi)
    * [Updating Docker-based modules](#updating-docker-based-modules)
    * [Updating Stripes](#updating-stripes)
* [Vagrantfile targets](#vagrantfile-targets)
* [Troubleshooting/Known Issues](#troubleshootingknown-issues)
    * [Vagrant "forwarded port to 9130 is already in use"](#vagrant-forwarded-port-to-9130-is-already-in-use)
    * [Viewing the Okapi log on the `backend`, `backend_auth`, or `demo` box](#viewing-the-okapi-log-on-the-backend-backendauth-or-demo-box)
    * [Viewing backend module logs on the `backend`, `backend_auth`, or `demo` box](#viewing-backend-module-logs-on-the-backend-backendauth-or-demo-box)
    * [Viewing the stripes log on the `demo` box](#viewing-the-stripes-log-on-the-demo-box)
    * [Some recent Vagrant versions have non-working `curl`](#some-recent-vagrant-versions-have-non-working-curl)
    * [VERR_SVM_DISABLED](#verrsvmdisabled)
* [Additional information](#additional-information)

## Prebuilt Vagrant boxes

The Vagrantfile and Ansible playbooks and roles in this project are
used to generate three prebuilt Vagrant boxes, available on
[Hashicorp Atlas](https://atlas.hashicorp.com/folio):

* [folio/folio-demo](https://atlas.hashicorp.com/folio/boxes/folio-demo)
  -- a full-stack FOLIO system, with Okapi, mod-users, mod-metadata,
  Stripes, and the Stripes modules trivial, ui-okapi-console,
  ui-users, and ui-items.

* [folio/folio-backend](https://atlas.hashicorp.com/folio/boxes/folio-backend)
  -- a backend FOLIO system, with Okapi, mod-users, and the
  mod-metadata modules.

* [folio/folio-backend-auth](https://atlas.hashicorp.com/folio/boxes/folio-backend-auth)
  -- a backend FOLIO system with the mod-auth authentication
  subsystem, with Okapi, mod-users, mod-metadata, and the mod-auth
  modules. The authorization subsystem includes three sample users,
  `diku_admin` (password "admin"), `auth_test1` (password "diku"), and
  `auth_test2` (password "diku").

All Vagrant boxes come with sample user and inventory data. The
modules are enabled for the sample tenant, "diku".

To try out any of these boxes, create an empty directory, `cd` into
it, and initialize a Vagrantfile, e.g.:

    $ vagrant init --minimal folio/folio-demo

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
backend modules, `users-module` (from mod-users), `inventory` and
`inventory-storage` (from mod-metadata), and `login-module`,
`permissions-module` and `authtoken-module` (from mod-auth) are
deployed through Okapi using its Docker deployment facility. `systemd`
service units are used to manage starting and stopping backend modules
and Stripes. Modules are installed following the convention of
configuration in `/etc/folio` and static files in `/usr/share/folio`.

Data is persisted for all modules using a PostgreSQL server running on
the Vagrant box. The Docker engine is also installed, and configured
to listen on localhost:4243 of the Vagrant box so that Okapi can use
it for module deployment.

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

    $ sudo apt-get update
    $ sudo apt-get install okapi

### Updating Docker-based modules

    # for a list of images
    $ sudo docker images
    
    # to update mod-users
    $ sudo docker pull folioci/mod-users

    # to undeploy and redeploy using the new image
    $ sudo systemctl restart mod-users

### Updating Stripes

To update Stripes or any Stripes components, update the Stripes
`package.json` file at `/etc/folio/stripes/package.json`, changing the
version of the component in the `dependencies`. Then `cd` to
`/usr/share/folio/stripes` and type the following commands:

    $ sudo -u okapi yarn install
    $ sudo systemctl restart stripes

## Vagrantfile targets

The Vagrantfile in this project contains six target definitions:

1. `backend` -- This target pulls the folio/folio-backend Vagrant box
   hosted on Atlas.
2. `backend_auth` -- This target pulls the folio/folio-backend-auth
   Vagrant box hosted on Atlas.
3. `demo` -- This target pulls the folio/folio-demo Vagrant box hosted
   on Atlas.
4. `build_backend` -- a target to build the `backend` box for
   packaging.
5. `build_backend_auth` -- a target to build the `backend_auth` box
   for packaging.
6. `build_demo` -- a target to build the `demo` box for packaging. 

## Troubleshooting/Known Issues

### Vagrant "forwarded port to 9130 is already in use"

All the Vagrant boxes defined in the Vagrantfile forward port 9130
(Okapi) on the guest VM to port 9130 on the host. To change the port
forwarding so that you can run multiple boxes at the same time, edit
the Vagrantfile in the root directory of the project.

### Viewing the Okapi log on the `backend`, `backend_auth`, or `demo` box

The Okapi logfile is at `/var/log/folio/okapi/okapi.log`.

### Viewing backend module logs on the `backend`, `backend_auth`, or `demo` box

Backend modules on the prebuilt boxes are deployed by Okapi as Docker
containers. To view the logs:

1. Log into the box using `vagrant ssh`.
2. Get the container name of the module you want to check with `sudo
docker ps`.
3. Look at the log with `sudo docker logs <container_name>`. You can
   follow the log by adding the `--follow` paramenter to the `docker
   logs` command.

### Viewing the stripes log on the `demo` box

On the `demo` box, stripes is deployed as a system service using
systemd. You can view the log by logging into the box with
`vagrant ssh demo`, then:

    $ sudo journalctl -u stripes

To follow the log:

    $ sudo journalctl -u stripes -f

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

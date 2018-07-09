# folio-ansible - Vagrant VMs and Ansible Roles

<!-- ../../okapi/doc/md2toc -l 2 index.md -->
* [Prebuilt Vagrant boxes](#prebuilt-vagrant-boxes)
* [FOLIO system setup on Vagrant boxes](#folio-system-setup-on-vagrant-boxes)
* [Replace localhost by hostname on the demo box](#replace-localhost-by-hostname-on-the-demo-box)
* [Replace port 9130](#replace-port-9130)
* [Updating FOLIO components on Vagrant boxes](#updating-folio-components-on-vagrant-boxes)
    * [Updating Okapi](#updating-okapi)
    * [Updating Docker-based modules](#updating-docker-based-modules)
    * [Updating Stripes](#updating-stripes)
* [Vagrantfile targets](#vagrantfile-targets)
* [Troubleshooting/Known Issues](#troubleshootingknown-issues)
    * [404 error on Vagrant box update](#404-error-on-vagrant-box-update)
    * [Vagrant "forwarded port is already in use"](#vagrant-forwarded-port-is-already-in-use)
    * [Viewing the Okapi log](#viewing-the-okapi-log)
    * [Viewing backend module logs](#viewing-backend-module-logs)
    * [Viewing the Stripes log](#viewing-the-stripes-log)
    * [Authentication failure after vagrant box update](#authentication-failure-after-vagrant-box-update)
    * [Launching Vagrant on Windows](#launching-vagrant-on-windows)
    * [Some recent Vagrant versions have non-working `curl`](#some-recent-vagrant-versions-have-non-working-curl)
    * [BIOS virtualization configuration](#bios-virtualization-configuration)
* [Additional information](#additional-information)

## Prebuilt Vagrant boxes

The Vagrantfile and Ansible playbooks and roles in this project are
used to generate prebuilt Vagrant boxes, available on
[Vagrant Cloud](https://app.vagrantup.com/folio):

* [folio/stable](https://app.vagrantup.com/folio/boxes/stable) -- a
  full-stack FOLIO system with stable releases of front- and
  backend modules. All components should interoperate correctly.

* [folio/stable-backend](https://app.vagrantup.com/folio/boxes/stable-backend)
  -- a backend FOLIO system with stable releases of backend modules. All
  components should interoperate correctly.

* [folio/snapshot](https://app.vagrantup.com/folio/boxes/snapshot)
  -- a full-stack FOLIO system, built from the most recent working
  commits to frontend components and the matching releases of the
  backend modules.

* [folio/testing](https://app.vagrantup.com/folio/boxes/testing) --
  a full-stack FOLIO system, with the very latest releases of front- and
  backend modules. Absolutely _not_ guaranteed to interoperate
  correctly.

* [folio/testing-backend](https://app.vagrantup.com/folio/boxes/testing-backend)
  -- a backend FOLIO system, with the very latest releases of backend
  modules. Absolutely _not_ guaranteed to interoperate correctly.

* [folio/minimal](https://app.vagrantup.com/folio/boxes/minimal)
  -- a minimal FOLIO system with just Okapi and no modules or sample data
  loaded.

* [folio/curriculum](https://app.vagrantup.com/folio/boxes/curriculum)
  -- a box built to support the
  [FOLIO Developer Curriculum](https://github.com/folio-org/curriculum),
  with prerequisites installed.

All Vagrant boxes come with sample user and inventory data. The
modules are enabled for the sample tenant, "diku".

To try out any of these boxes, create an empty directory, `cd` into
it, and initialize a Vagrantfile, e.g.:

    $ vagrant init --minimal folio/stable

If you have downloaded a previous version of the box, then from
time-to-time it will need to be updated with `vagrant box update`
(followed by `vagrant destroy` to disable the old default machine).
The Vagrant box can then be launched with `vagrant up`.

Okapi will be listening on localhost
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

To make the demo box accessible from machines other than the local one,
Stripes needs the hostname of the backend. Use this `Vagrantfile` to
configure the hostname:

    Vagrant.configure("2") do |config|
      config.vm.box = "folio/testing"

      config.vm.provision "shell", env: {
        "URL" => "http://example.com:9130"
      }, inline: <<-SHELL
        set -e
        sed -i -e "s=\\(okapi: *{ *'url': *\\)'[^']*'=\\1'$URL'=" /etc/folio/stripes/stripes.config.js
        /etc/folio/stripes/build-run
      SHELL
    end

## Replace port 9130

This is an example how to avoid using port 9130 that may be blocked at
some institutions. Instead all front-end and back-end requests arrive
at the same default port (80 for HTTP or 443 for HTTPS). Configure the
URL like `http://example.com` or `https://example.com` as explained in
the previous section.

An nginx in front of the Vagrant box proxies the requests to ports
3000 and 9130. This snippet shows how to do it:

    # Frontend requests:
    # index file at / and all *.ico, *,png, *.css, *.js, *.js.map files in the root directory and
    # the /bootstrap/ and /fonts/ and /img/ and /translations/ directories.
    location ~ ^(/|/[0-9a-zA-Z.-]+\.(ico|png|css|js|js\.map)|/bootstrap/.*|/fonts/.*|/img/.*|/translations/.*)$ {
        proxy_pass http://127.0.0.1:3000;
    }

    # Backend requests:
    location / {
        proxy_pass http://127.0.0.1:9130;
    }

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

    # To update a module, first undeploy the modules using the
    # okapi-deploy service:
    $ sudo systemctl stop okapi-deploy

    # If you want the latest version of the module, just do a
    # docker pull:
    $ docker pull folioci/mod-users:latest

    # To update to a specific version of a module,
    # edit its deployment descriptor to update
    # the version specified and pull the image, e.g.:
    $ sudo vi /etc/folio/deployment-descriptors/mod-users.json
    $ docker pull folioci/mod-users:14.4.1-SNAPSHOT.13

    # Then redeploy using the new image
    $ sudo systemctl start okapi-deploy

### Updating Stripes

To update Stripes or any Stripes components, update the Stripes
`package.json` file at `/etc/folio/stripes/package.json`, changing the
version of the component in the `dependencies`. If you want to change
the npm repository for FOLIO libraries, you should also update
`/etc/folio/stripes/.npmrc`. Then rebuild the yarn platform and
Docker container and restart it:

    $ cd /etc/folio/stripes
    $ sudo yarn upgrade
    $ ./build-run

## Vagrantfile targets

The Vagrantfile in this project contains six target definitions:

1. `stable` -- This target pulls the folio/stable Vagrant box hosted
   on Vagrant Cloud.
2. `stable-backend` -- This target pulls the folio/stable-backend
   Vagrant box hosted on Vagrant Cloud.
3. `testing` -- This target pulls the folio/testing
   Vagrant box hosted on Vagrant Cloud.
4. `testing-backend` -- This target pulls the folio/testing-backend
   Vagrant box hosted on Vagrant Cloud.
5. `curriculum` -- This target pulls the folio/curriculum Vagrant box
   hosted on Vagrant Cloud.
6. `build_stable` -- a target to build the `stable` box for packaging.
7. `build_stable_backend` -- a target to build the `stable-backend`
   box for packaging.
8. `build_testing` -- a target to build the `testing` box
   for packaging.
9. `build_curriculum` -- a target to build the `curriculum` box for
   packaging.

## Troubleshooting/Known Issues

### 404 error on Vagrant box update

As of 5 Feb 2018: If you have an existing Vagrant VM based on a
Vagrant box file created before this date, you may have an issue with
the metadata URL for the box file. Check the file
`cat ~/.vagrant.d/boxes/<box ID>/metadata_url`. If it has an address of the
form `https://atlas.hashicorp.com/[...]` then the `atlas.hashicorp`
needs to be replaced with `vagrantcloud`.

(Note: Do not use a text-editor, as they are not proper text files.
They have no final newline, and if added then vagrant will break.
Perl can [rescue](https://stackoverflow.com/questions/16365155/removing-a-newline-character-at-the-end-of-a-file).)

To replace the metadata URL for all the boxes in your `~/.vagrant.d`
directory, use the following `Perl one-liner` script:

    perl -p -i -e 's/atlas.hashicorp/vagrantcloud/' ~/.vagrant.d/boxes/*/metadata_url

If you are using a version of Vagrant \<= 1.9.6,
upgrade Vagrant to prevent future problems initializing Vagrant VMs.

For more information, see https://github.com/hashicorp/vagrant/issues/9442

### Vagrant "forwarded port is already in use"

The prebuilt Vagrant boxes come with a packaged Vagrantfile that forwards port 9130
(Okapi) and port 3000 (stripes) on the guest VM to the same ports on
the host. This can cause conflicts with running services on the host
machine. To change the port forwarding settings, edit your Vagrantfile
to add the line(s):

    config.vm.network "forwarded_port", guest: 3000, host: 3000, disabled: true
    config.vm.network "forwarded_port", guest: 9130, host: 9130, disabled: true

And then add lines to forward the Okapi and/or stripes ports to
whichever ports you prefer.

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

### Authentication failure after vagrant box update

After starting 'vagrant up' it may advise that a newer version of the box is available.
So do `vagrant halt; vagrant box update; vagrant destroy; vagrant up`.
If the 'vagrant destroy' step is missed, then after doing 'vagrant up' it may report:

```
   ...
   default: SSH username: vagrant
   default: SSH auth method: private key
   default: Warning: Authentication failure. Retrying...
   default: Warning: Authentication failure. Retrying...
   ... (repeated)
```

So interrupt it, and then do `vagrant destroy` before starting up the new box:

```
Ctrl-C
vagrant halt
vagrant destroy
vagrant up
```

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

### BIOS virtualization configuration

Trying to start VirtualBox may fail with the message:

> Stderr: VBoxManage: error: AMD-V is disabled in the BIOS (or by the host OS) (VERR_SVM_DISABLED)

This indicates that the BIOS of the host hardware is not configured to
support virtualization. The only fix is to reboot the host and poke
around in the BIOS settings. The necessary setting should be found in
the CPU Configuration, and will have a name like SVM, Secure Virtual
Machine Mode or AMD-V. Good luck!

## Additional information

* [Ansible groups](ansible-groups.md), [Ansible roles](ansible-roles.md) and
  [Ansible variables](ansible-variables.md) used in this project
* [Vagrant documentation](https://www.vagrantup.com/docs/)
* [Ansible documentation](http://docs.ansible.com/ansible/index.html)
* [Docker documentation](https://docs.docker.com/)
* Other FOLIO Developer documentation is at [dev.folio.org](https://dev.folio.org/)

# folio-ansible - Vagrant VMs and Ansible Roles

<!-- ../../okapi/doc/md2toc -l 2 index.md -->
* [Vagrantfile targets](#vagrantfile-targets)
* [Troubleshooting/Known Issues](#troubleshootingknown-issues)
    * [Vagrant "forwarded port to 9130 is already in use"](#vagrant-forwarded-port-to-9130-is-already-in-use)
    * [Viewing the Okapi log on the `backend` or `demo` box](#viewing-the-okapi-log-on-the-backend-or-demo-box)
    * [Viewing the stripes log on the `demo` box](#viewing-the-stripes-log-on-the-demo-box)
    * [Viewing the Okapi log on the `dev` box](#viewing-the-okapi-log-on-the-dev-box)
    * [Some recent Vagrant versions have non-working `curl`](#some-recent-vagrant-versions-have-non-working-curl)
    * [VERR_SVM_DISABLED](#verrsvmdisabled)
    * ["No running module instance found for mod-users" on `backend` or `demo` box](#no-running-module-instance-found-for-mod-users-on-backend-or-demo-box)
    * [Loading users on `dev` box](#loading-users-on-dev-box)
* [Additional information](#additional-information)

## Vagrantfile targets

The Vagrantfile in this project contains five target definitions:

1. `dev` -- a development box that runs Okapi and mod-users out of Docker
   containers, and loads sample user data. Okapi and mod-users are
   cloned from GitHub and then built from source on the VM as part of
   provisioning. Source code is shared with the host machine on the
   project root.
2. `backend` -- a fully loaded backend Okapi and mod-users system with
   sample data.
3. `demo` -- a fully loaded backend Okapi and mod-users system with
   sample data, stripes-core loaded as a system service, and the
   ui-users FOLIO app.
4. `build_backend` -- a target to build the `backend` box for
   packaging.
5. `build_demo` -- a target to build the `demo` box for packaging.

## Troubleshooting/Known Issues

### Vagrant "forwarded port to 9130 is already in use"

All the Vagrant boxes defined in the Vagrantfile forward port 9130
(Okapi) on the guest VM to port 9130 on the host. To change the port
forwarding so that you can run multiple boxes at the same time, edit
the Vagrantfile in the root directory of the project.

### Viewing the Okapi log on the `backend` or `demo` box

On the `backend` and `demo` boxes, Okapi is deployed as a system
service using
[systemd](https://www.freedesktop.org/wiki/Software/systemd/), the
Debian standard, so you can use the standard systemd tools to look at
the log. First log into the box with `vagrant ssh backend` or `vagrant
ssh demo`, then:

    $ sudo journalctl -u okapi

To follow the log:

    $ sudo journalctl -u okapi -f

### Viewing the stripes log on the `demo` box

On the `demo` box, stripes is deployed as a system service using
systemd, like Okapi. You can view the log by logging into the box with
`vagrant ssh demo`, then:

    $ sudo journalctl -u stripes

To follow the log:

    $ sudo journalctl -u stripes -f

### Viewing the Okapi log on the `dev` box

On the `dev` box, Okapi is deployed as a Docker container. You can use
the Docker tools to look at the log. First log into the box with
`vagrant ssh dev`, then:

    $ docker logs okapi

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

### "No running module instance found for mod-users" on `backend` or `demo` box

This can happen if for some reason the okapi service on the box failed
to start up quickly enough for the mod-users service to deploy. To
fix:

1. Log into the box with `vagrant ssh backend` or `vagrant ssh demo`
2. `sudo systemctl status mod-users`

A running mod-users module will show output like this:

```
vagrant@contrib-jessie:~$ sudo systemctl status mod-users
● mod-users.service - Deploy FOLIO mod-users module to Okapi on localhost
   Loaded: loaded (/etc/systemd/system/mod-users.service; enabled)
   Active: inactive (dead) since Thu 2016-12-08 22:31:08 GMT; 9min ago
  Process: 769 ExecStart=/usr/bin/curl -s -X POST -H Content-Type: application/json -d @/opt/mod-users/conf/DeploymentDescriptor.json http://localhost:9130/_/discovery/modules (code=exited, status=0/SUCCESS)
 Main PID: 769 (code=exited, status=0/SUCCESS)

Dec 08 22:31:08 contrib-jessie curl[769]: {
Dec 08 22:31:08 contrib-jessie curl[769]: "instId" : "localhost-9131",
Dec 08 22:31:08 contrib-jessie curl[769]: "srvcId" : "mod-users",
Dec 08 22:31:08 contrib-jessie curl[769]: "nodeId" : "localhost",
Dec 08 22:31:08 contrib-jessie curl[769]: "url" : "http://localhost:9131",
Dec 08 22:31:08 contrib-jessie curl[769]: "descriptor" : {
Dec 08 22:31:08 contrib-jessie curl[769]: "exec" : "java -jar /opt/mod-users/lib/mod-users-fat.jar -Dhttp.port=...json"
Dec 08 22:31:08 contrib-jessie curl[769]: }
Dec 08 22:31:08 contrib-jessie curl[769]: }
Dec 08 22:31:08 contrib-jessie systemd[1]: Started Deploy FOLIO mod-users module to Okapi on localhost.
Hint: Some lines were ellipsized, use -l to show in full.
```

If you don't see the descriptor in the log output, the service may not
have deployed. Try:

    $ sudo systemctl start mod-users

To view the log output:

    $ sudo journalctl -u mod-users

### Loading users on `dev` box

Sometimes users do not correctly load when provisioning the `dev`
Vagrant box, due to a timing issue (some components may not spin up
before the provisioning script attempts to load the users). It can
typically be fixed by running:

    $ vagrant provision dev

(If necessary, multiple times.)

## Additional information

* [Ansible roles](ansible-roles.md) and
  [Ansible variables](ansible-variables.md) used in this project
* [Vagrant documentation](https://www.vagrantup.com/docs/)
* [Ansible documentation](http://docs.ansible.com/ansible/index.html)
* [Docker documentation](https://docs.docker.com/)
* Other FOLIO Developer documentation is at [dev.folio.org](http://dev.folio.org/)

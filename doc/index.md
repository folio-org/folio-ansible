# folio-ansible - Vagrant VMs and Ansible Roles

<!-- ../../okapi/doc/md2toc -l 2 index.md -->
* [Prebuilt Vagrant boxes](#prebuilt-vagrant-boxes)
* [FOLIO system setup on Vagrant boxes](#folio-system-setup-on-vagrant-boxes)
* [Log files](#log-files)
    * [Viewing the Okapi log](#viewing-the-okapi-log)
    * [Viewing backend module logs](#viewing-backend-module-logs)
    * [Viewing the Stripes log](#viewing-the-stripes-log)
* [Running backend modules on your host system](#running-backend-modules-on-your-host-system)
* [Replace localhost by hostname on the demo box](#replace-localhost-by-hostname-on-the-demo-box)
* [Replace port 9130](#replace-port-9130)
* [Updating FOLIO components on Vagrant boxes](#updating-folio-components-on-vagrant-boxes)
    * [Updating Okapi](#updating-okapi)
    * [Updating FOLIO backend modules](#updating-folio-backend-modules)
    * [Updating Stripes](#updating-stripes)
* [Vagrantfile targets](#vagrantfile-targets)
* [Troubleshooting/Known Issues](#troubleshootingknown-issues)
    * [404 error on Vagrant box update](#404-error-on-vagrant-box-update)
    * [Vagrant "forwarded port is already in use"](#vagrant-forwarded-port-is-already-in-use)
    * [Authentication failure after vagrant box update](#authentication-failure-after-vagrant-box-update)
    * [Launching Vagrant on Windows](#launching-vagrant-on-windows)
    * [Some recent Vagrant versions have non-working `curl`](#some-recent-vagrant-versions-have-non-working-curl)
    * [BIOS virtualization configuration](#bios-virtualization-configuration)
* [Additional information](#additional-information)

## Prebuilt Vagrant boxes

The Vagrantfile and Ansible playbooks and roles in this project are
used to generate prebuilt Vagrant boxes, available on
[Vagrant Cloud](https://app.vagrantup.com/folio):

* [folio/release](https://app.vagrantup.com/folio/boxes/release) -- a
  full-stack FOLIO system with stable releases of front- and
  backend modules. All components should interoperate correctly.
  This is the most recent "[flower release](https://dev.folio.org/guides/regular-releases/)".

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

All Vagrant boxes come with sample user and inventory data. The
modules are enabled for the sample tenant, "diku".

To try out any of these boxes, create an empty directory, `cd` into
it, and initialize a Vagrantfile, e.g.:

    $ vagrant init --minimal folio/testing-backend

If you have downloaded a previous version of the box, then from
time-to-time it will need to be updated with `vagrant box update`
(followed by `vagrant destroy` to disable the old default machine).
The Vagrant box can then be launched with `vagrant up`.

Do `vagrant ssh` and watch Okapi preparing the system:
`docker logs okapi --follow`

The [Tutorial](https://dev.folio.org/tutorials/folio-vm/)
provides further introduction to using these boxes.

However, as explained there, wait a while before attempting to interact
because Okapi will still be starting modules.

Okapi will be listening on localhost port 9130. On the `release`,
`snapshot`, and `testing` boxes, there will be an nginx server with a
FOLIO UI bundle listening on localhost port 3000, and another nginx
server proxying edge modules on port 8000.

## FOLIO system setup on Vagrant boxes

The prebuilt Vagrant boxes have the FOLIO stack set up for convenient
development. The base distribution is Linux Ubuntu Focal (20.04).

* PostgreSQL and the Docker Engine are installed as system services
  from those projects' APT repositories.

* Kafka/Zookeeper and Elasticsearch are deployed as Docker containers
  using container images from those projects.

* Okapi is deployed as a Docker container using a container image
  from the FOLIO project. It uses the configuration file at
  `/etc/folio/okapi/okapi.json`.

* The FOLIO UI is installed as a Docker container running nginx, with
  the Stripes UI bundled as the default document.

* For boxes that include edge modules, nginx is installed from the
  Ubuntu APT repository to proxy edge module traffic.

* All FOLIO backend modules are deployed through Okapi using its
  Docker deployment facility.

* Edge modules are deployed as Docker containers.

All FOLIO project containers are based on the images that are
[published](https://dev.folio.org/download/artifacts/#docker-images)
by the project on Docker Hub at
[folioorg](https://hub.docker.com/u/folioorg) and
[folioci](https://hub.docker.com/u/folioci).

## Log files

The log files of all modules can be viewed by logging into the box
with `vagrant ssh`, and then using `docker logs <container_name>`.

Follow the logs by appending `--follow` parameter to the `docker logs` command.

### Viewing the Okapi log

Okapi is deployed as a Docker container. To watch its log, use
`docker logs okapi --follow`

### Viewing backend module logs

Backend modules on the prebuilt boxes are deployed by Okapi as Docker
containers. To view the logs:

1. Log into the box using `vagrant ssh`.
2. Get the container name of the module you want to check by using `docker ps`.
3. Look at the log with `docker logs <container_name>`.

### Viewing the Stripes log

Stripes is deployed as a Docker container.

    $ docker logs stripes_stripes_1

To follow the log:

    $ docker logs stripes_stripes_1 --follow

## Running backend modules on your host system

You can make a service running on your host system available to the
Okapi system running in a Vagrant VM by configuring a "host-only"
private network in VirtualBox and reconfiguring Okapi on the VM to use
the private network IP as its `X-Okapi-URL` header. To set this up:

1. Set up a "host only" network in VirtualBox that your VM can connect
   to. See the
   [VirtualBox Documentation](https://www.virtualbox.org/manual/ch06.html#network_hostonly)
   for details. This will set up a private network on your host with
   your host as the first address in the address space.

2. Update the Vagrantfile for your Vagrant VM to add a new network
   adapter. The default (NAT) network adapter will still be created as
   eth0. The host-only network will be on eth1. Your Vagrantfile will
   need to look something like this (the `ip` key is for you to assign
   an IP address on the host-only network):

```
Vagrant.configure("2") do |config|
  config.vm.box = "folio/snapshot-backend-core"
  config.vm.network "private_network", ip: "192.168.56.101"
end
```

3. Bring up the VM with `vagrant up` and log into it with `vagrant
   ssh`. `ip a l` should show you 2 network interfaces, eth0 with
   address 10.0.2.15 and eth1 with the address you assign from the
   host-only network.

4. Take down Okapi on the VM with `docker stop okapi`.

5. Update the Okapi configuration file
   `/etc/folio/okapi/okapi.json`. Change the value of the `okapiurl`
   property from `http://10.0.2.15:9130` to the newly assigned
   host-only network address (in the example above,
   `http://192.168.56.101:9130`). Restart Okapi with `docker restart okapi`.

6. Build and run the module locally on an available port on the host
   machine. Your module will have access to the PostgreSQL database on
   the guest VM if needed, at the assigned address (in the example,
   `192.168.56.101:5432`).

7. Post a module descriptor for the local module to the Okapi running
   in the Vagrant VM, using the Okapi `/_/proxy/modules` endpoint.

8. Post a deployment descriptor for the local module with a URL
   pointing to the host-only gateway, using the Okapi
   `/_/discovery/modules` endpoint. For example:

```json
{
  "srvcId": "mod-mymod-0.1.0",
  "instId": "mod-mymod-on-host",
  "url": "http://192.168.56.1:8081"
}
```

9. Enable the module for the default tenant by posting to the Okapi
   `/_/proxy/tenants/diku/install` endpoint. For example:

```json
[
  {
    "id": "mod-mymod-0.1.0",
    "action": "enable"
  }
]
```

To upgrade an existing module for the default tenant to use a local
module, follow the same procedure, but use Okapi's upgrade facility
when posting to `/_/proxy/tenants/diku/install`. For example:

```json
[
  {
    "id": "mod-tags-0.3.0",
    "from": "mod-tags-0.2.0",
    "action": "enable"
  }
]
```

For more details on working with Okapi's module API, see the
[Okapi Guide](https://github.com/folio-org/okapi/blob/master/doc/guide.md). Some
of these interactions can be simplified by using the Stripes CLI to
manage modules, see the
[Stripes CLI Back-end Guide](https://github.com/folio-org/stripes-cli/blob/master/doc/backend-guide.md).

## Replace localhost by hostname on the demo box

To make the demo box accessible from machines other than the local one,
Stripes needs the Okapi URL for accessing the backend. Use this `Vagrantfile` to
configure it:

    Vagrant.configure("2") do |config|
      config.vm.box = "folio/testing"

      config.vm.provision "shell", env: {
        "OKAPI" => "http://example.com:9130"
      }, inline: <<-SHELL
        set -e
        docker stop okapi
        sleep 10
        docker ps -a -q | xargs --no-run-if-empty docker rm -f
        rm -rf /etc/folio/stripes/output
        /etc/folio/stripes/build-run
        docker start okapi
      SHELL
    end

## Replace port 9130

This is an example how to avoid using port 9130.
Instead all front-end and back-end requests arrive
at the same default port (80 for HTTP or 443 for HTTPS).

This has two advantages:
* Faster responses (less latency) because the browser no longer
  needs to send extra "preflight" OPTIONS HTTP requests for
  cross-origin resource sharing (CORS) protection.
* Avoids port 9130 that may be blocked at some institutions and
  at some internet access points.

Configure the Okapi URL like

    "OKAPI" => "http://example.com/okapi"

or

    "OKAPI" => "https://example.com/okapi"

as explained in
the previous section.

An nginx in front of the Vagrant box proxies the requests to ports
3000 and 9130. This snippet shows how to do it, note the presence/
absence of the trailing slash:

    # back-end requests:
    location /okapi/ {
        proxy_pass http://127.0.0.1:9130/;
        proxy_redirect default;
    }

    # front-end requests:
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_redirect default;
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

Since Okapi is running as a container, you can upgrade it by using
`docker pull` to pull in a new version and redeploying. For example,
to upgrade to the latest Okapi release from the folioorg image repository
on Docker Hub:

    $ docker stop okapi
    $ docker rm okapi
    $ docker run --detach --name okapi -v /etc/folio/okapi:/usr/verticles/okapi:ro --network host --restart always --env JAVA_OPTIONS='-Djava.awt.headless=true -Ddeploy.waitIterations=90' folioorg/okapi:latest dev -conf okapi/okapi.json

### Updating FOLIO backend modules

Since the Vagrant boxes use Okapi for module deployment, upgrading
backend modules is done using the Okapi API.

    # Get the newest module descriptors from the FOLIO repository
    $ curl -w '\n' -X POST -d '{"urls": ["https://folio-registry.dev.folio.org"]}' http://localhost:9130/_/proxy/pull/modules

    # Upgrade the module for the diku tenant
    $ curl -w '\n' -X POST -d '[{"id": "mod-email-1.12.0","action": "enable"}]' "http://localhost:9130/_/proxy/tenants/diku/install?deploy=true"

Okapi will deploy the new version of the module, enable it for the
tenant, and undeploy the old version.

To use a Vagrant box with local module versions that are not included
in the FOLIO Docker image repositories, see
[Running backend modules on your host system](#running-backend-modules-on-your-host-system).

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

The Vagrantfile in this project contains various target definitions, for example:

* `build_testing_backend` -- a target to build the `testing-backend` box
   for packaging.
* `testing-backend` -- This target pulls the folio/testing-backend
   Vagrant box hosted on Vagrant Cloud.

Similar targets are provided for the various boxes [described](#prebuilt-vagrant-boxes) above, and others.

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

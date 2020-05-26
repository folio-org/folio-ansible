# -*- mode: ruby -*-
# vi: set ft=ruby :
# Build a VM to serve as an Okapi/Docker server
# Deploy development environment

Vagrant.configure(2) do |config|

  # Give us a little headroom
  # Note that provisioning a Stripes webpack requires more RAM
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 8192
    vb.cpus = 2
  end

  config.vm.define "snapshot-core", autostart: false do |snapshot_core|
    snapshot_core.vm.box = "folio/snapshot-core"
    snapshot_core.vm.network "forwarded_port", guest: 9130, host: 9130
    snapshot_core.vm.network "forwarded_port", guest: 3000, host: 3000
    snapshot_core.vm.network "forwarded_port", guest: 8000, host: 8130
  end

  config.vm.define "snapshot-backend-core", autostart: false do |snapshot_backend_core|
    snapshot_backend_core.vm.box = "folio/snapshot-backend-core"
    snapshot_backend_core.vm.network "forwarded_port", guest: 9130, host: 9130
    snapshot_backend_core.vm.network "forwarded_port", guest: 8000, host: 8130
  end

  config.vm.define "testing", autostart: false do |testing|
    testing.vm.box = "folio/testing"
    testing.vm.network "forwarded_port", guest: 9130, host: 9130
    testing.vm.network "forwarded_port", guest: 3000, host: 3000
    testing.vm.network "forwarded_port", guest: 8000, host: 8130
  end

  config.vm.define "testing-backend", autostart: false do |testing_backend|
    testing_backend.vm.box = "folio/testing-backend"
    testing_backend.vm.network "forwarded_port", guest: 9130, host: 9130
    testing_backend.vm.network "forwarded_port", guest: 8000, host: 8130
  end

  config.vm.define "snapshot", autostart: false do |snapshot|
    snapshot.vm.box = "folio/snapshot"
    snapshot.vm.network "forwarded_port", guest: 9130, host: 9130
    snapshot.vm.network "forwarded_port", guest: 3000, host: 3000
    snapshot.vm.network "forwarded_port", guest: 8000, host: 8130
  end

  config.vm.define "build_snapshot_core", autostart: false do |build_snapshot_core|
    build_snapshot_core.vm.box = "bento/ubuntu-16.04"
    build_snapshot_core.vm.provider "virtualbox" do |vt|
      vt.memory = 10240
    end
    build_snapshot_core.vm.network "forwarded_port", guest: 9130, host: 9130
    build_snapshot_core.vm.network "forwarded_port", guest: 3000, host: 3000
    build_snapshot_core.vm.network "forwarded_port", guest: 8000, host: 8130
    build_snapshot_core.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_snapshot_core"],
        "snapshot-core" => ["build_snapshot_core"],
        "stripes-docker" => ["build_snapshot_core"]
      }
    end
  end

  config.vm.define "build_snapshot_backend_core", autostart: false do |build_snapshot_backend_core|
    build_snapshot_backend_core.vm.box = "bento/ubuntu-16.04"
    build_snapshot_backend_core.vm.provider "virtualbox" do |vt|
      vt.memory = 10240
    end
    build_snapshot_backend_core.vm.network "forwarded_port", guest: 9130, host: 9130
    build_snapshot_backend_core.vm.network "forwarded_port", guest: 8000, host: 8130
    build_snapshot_backend_core.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_snapshot_backend_core"],
        "snapshot-core" => ["build_snapshot_backend_core"]
      }
    end
  end

  config.vm.define "build_testing", autostart: false do |build_testing|
    build_testing.vm.box = "bento/ubuntu-16.04"
    build_testing.vm.provider "virtualbox" do |vt|
      vt.memory = 10240
    end
    build_testing.vm.network "forwarded_port", guest: 9130, host: 9130
    build_testing.vm.network "forwarded_port", guest: 3000, host: 3000
    build_testing.vm.network "forwarded_port", guest: 8000, host: 8130
    build_testing.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_testing"],
        "testing" => ["build_testing"],
        "stripes" => ["build_testing"]
      }
    end
  end

  config.vm.define "build_testing_backend", autostart: false do |build_testing_backend|
    build_testing_backend.vm.box = "bento/ubuntu-16.04"
    build_testing_backend.vm.provider "virtualbox" do |vtb|
      vtb.memory = 10240
    end
    build_testing_backend.vm.network "forwarded_port", guest: 9130, host: 9130
    build_testing_backend.vm.network "forwarded_port", guest: 8000, host: 8130
    build_testing_backend.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_testing_backend"],
        "testing" => ["build_testing_backend"],
        "stripes-build" => ["build_testing_backend"]
      }
    end
  end

  config.vm.define "build_testing_core", autostart: false do |build_testing_core|
    build_testing_core.vm.box = "bento/ubuntu-16.04"
    build_testing_core.vm.provider "virtualbox" do |vt|
      vt.memory = 10240
    end
    build_testing_core.vm.network "forwarded_port", guest: 9130, host: 9130
    build_testing_core.vm.network "forwarded_port", guest: 3000, host: 3000
    build_testing_core.vm.network "forwarded_port", guest: 8000, host: 8130
    build_testing_core.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_testing_core"],
        "testing-core" => ["build_testing_core"],
        "stripes" => ["build_testing_core"]
      }
    end
  end

  config.vm.define "build_testing_backend_core", autostart: false do |build_testing_backend_core|
    build_testing_backend_core.vm.box = "bento/ubuntu-16.04"
    build_testing_backend_core.vm.provider "virtualbox" do |vtb|
      vtb.memory = 10240
    end
    build_testing_backend_core.vm.network "forwarded_port", guest: 9130, host: 9130
    build_testing_backend_core.vm.network "forwarded_port", guest: 8000, host: 8130
    build_testing_backend_core.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_testing_backend_core"],
        "testing-core" => ["build_testing_backend_core"],
        "stripes-build" => ["build_testing_backend_core"]
      }
    end
  end

  config.vm.define "build_snapshot", autostart: false do |build_snapshot|
    build_snapshot.vm.box = "bento/ubuntu-16.04"
    build_snapshot.vm.network "forwarded_port", guest: 9130, host: 9130
    build_snapshot.vm.network "forwarded_port", guest: 3000, host: 3000
    build_snapshot.vm.network "forwarded_port", guest: 8000, host: 8130
    build_snapshot.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_snapshot"],
        "snapshot" => ["build_snapshot"],
        "stripes-docker" => ["build_snapshot"]
      }
    end
  end

  config.vm.define "build_release_core", autostart: false do |build_release_core|
    build_release_core.vm.box = "bento/ubuntu-16.04"
    build_release_core.vm.provider "virtualbox" do |vr|
      vr.memory = 10240
    end
    build_release_core.vm.network "forwarded_port", guest: 9130, host: 9130
    build_release_core.vm.network "forwarded_port", guest: 3000, host: 3000
    build_release_core.vm.network "forwarded_port", guest: 8000, host: 8130
    build_release_core.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_release_core"],
        "release-core" => ["build_release_core"],
        "stripes" => ["build_release_core"]
      }
    end
  end

  config.vm.define "build_minimal", autostart: false do |build_minimal|
    build_minimal.vm.box = "debian/contrib-jessie64"
    build_minimal.vm.network "forwarded_port", guest: 9130, host: 9130
    build_minimal.vm.synced_folder ".", "/vagrant", disabled: true
    build_minimal.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_minimal"],
        "minimal" => ["build_minimal"]
      }
    end
  end

end

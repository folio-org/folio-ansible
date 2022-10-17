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

# deprecated
  config.vm.define "testing", autostart: false do |testing|
    testing.vm.box = "folio/testing"
    testing.vm.network "forwarded_port", guest: 9130, host: 9130
    testing.vm.network "forwarded_port", guest: 3000, host: 3000
    testing.vm.network "forwarded_port", guest: 8000, host: 8130
  end

# deprecated
  config.vm.define "testing-backend", autostart: false do |testing_backend|
    testing_backend.vm.box = "folio/testing-backend"
    testing_backend.vm.network "forwarded_port", guest: 9130, host: 9130
    testing_backend.vm.network "forwarded_port", guest: 8000, host: 8130
  end

  config.vm.define "snapshot", autostart: false do |snapshot|
    snapshot.vm.box = "folio/snapshot"
    snapshot.vm.provider "virtualbox" do |vb|
      vb.memory = 20480
    end
    snapshot.vm.network "forwarded_port", guest: 9130, host: 9130
    snapshot.vm.network "forwarded_port", guest: 3000, host: 3000
    snapshot.vm.network "forwarded_port", guest: 8000, host: 8130
  end

# deprecated
  config.vm.define "release-core", autostart: false do |snapshot|
    snapshot.vm.box = "folio/release-core"
    snapshot.vm.network "forwarded_port", guest: 9130, host: 9130
    snapshot.vm.network "forwarded_port", guest: 3000, host: 3000
    snapshot.vm.network "forwarded_port", guest: 8000, host: 8130
  end

  config.vm.define "release", autostart: false do |release|
    release.vm.box = "folio/release"
    release.vm.provider "virtualbox" do |vb|
      vb.memory = 20480
    end
    release.vm.network "forwarded_port", guest: 9130, host: 9130
    release.vm.network "forwarded_port", guest: 3000, host: 3000
    release.vm.network "forwarded_port", guest: 8000, host: 8130
  end

# deprecated
  config.vm.define "build_testing", autostart: false do |build_testing|
    build_testing.vm.box = "bento/ubuntu-20.04"
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

# deprecated
  config.vm.define "build_testing_backend", autostart: false do |build_testing_backend|
    build_testing_backend.vm.box = "bento/ubuntu-20.04"
    build_testing_backend.vm.provider "virtualbox" do |vtb|
      vtb.memory = 20480
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

  config.vm.define "build_snapshot", autostart: false do |build_snapshot|
    build_snapshot.vm.box = "bento/ubuntu-20.04"
    build_snapshot.vm.network "forwarded_port", guest: 9130, host: 9130
    build_snapshot.vm.network "forwarded_port", guest: 3000, host: 3000
    build_snapshot.vm.network "forwarded_port", guest: 8000, host: 8130
    build_snapshot.vm.provider "virtualbox" do |vb|
      vb.memory = 20480
    end
    build_snapshot.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_snapshot"],
        "snapshot" => ["build_snapshot"],
        "stripes-docker" => ["build_snapshot"]
      }
    end
  end

# deprecated
  config.vm.define "build_release_core", autostart: false do |build_release_core|
    build_release_core.vm.box = "bento/ubuntu-20.04"
    build_release_core.vm.provider "virtualbox" do |vr|
      vr.memory = 12288
    end
    build_release_core.vm.network "forwarded_port", guest: 9130, host: 9130
    build_release_core.vm.network "forwarded_port", guest: 3000, host: 3000
    build_release_core.vm.network "forwarded_port", guest: 8000, host: 8130
    build_release_core.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_release_core"],
        "release-core" => ["build_release_core"],
        "stripes-docker" => ["build_release_core"]
      }
    end
  end

  config.vm.define "build_release", autostart: false do |build_release|
    build_release.vm.box = "bento/ubuntu-20.04"
    build_release.vm.provider "virtualbox" do |vrel|
      vrel.memory = 20480
    end
    build_release.vm.network "forwarded_port", guest: 9130, host: 9130
    build_release.vm.network "forwarded_port", guest: 3000, host: 3000
    build_release.vm.network "forwarded_port", guest: 8000, host: 8130
    build_release.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_release"],
        "release" => ["build_release"],
        "stripes" => ["build_release"]
      }
    end
  end

# deprecated
  config.vm.define "build_minimal", autostart: false do |build_minimal|
    build_minimal.vm.box = "bento/ubuntu-20.04"
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

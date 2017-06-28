# -*- mode: ruby -*-
# vi: set ft=ruby :
# Build a VM to serve as an Okapi/Docker server
# Deploy development environment

Vagrant.configure(2) do |config|

  # Give us a little headroom
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end

  config.vm.define "stable", autostart: false do |stable|
    stable.vm.box = "folio/stable"
    stable.vm.synced_folder ".", "/vagrant", disabled: true
    stable.vm.network "forwarded_port", guest: 9130, host: 9130
    stable.vm.network "forwarded_port", guest: 3000, host: 3000
  end

  config.vm.define "testing", autostart: false do |testing|
    testing.vm.box = "folio/testing"
    testing.vm.synced_folder ".", "/vagrant", disabled: true
    testing.vm.network "forwarded_port", guest: 9130, host: 9130
    testing.vm.network "forwarded_port", guest: 3000, host: 3000
  end

  config.vm.define "testing-backend", autostart: false do |testing_backend|
    testing_backend.vm.box = "folio/testing-backend"
    testing_backend.vm.synced_folder ".", "/vagrant", disabled: true
    testing_backend.vm.network "forwarded_port", guest: 9130, host: 9130
  end

  config.vm.define "curriculum", autostart: false do |curriculum|
    curriculum.vm.box = "folio/curriculum"
    curriculum.vm.network "forwarded_port", guest: 9130, host: 9130
    curriculum.vm.network "forwarded_port", guest: 3000, host: 3000
  end

  config.vm.define "build_stable", autostart: false do |build_stable|
    build_stable.vm.box = "debian/jessie64"
    build_stable.vm.network "forwarded_port", guest: 9130, host: 9130
    build_stable.vm.network "forwarded_port", guest: 3000, host: 3000
    build_stable.vm.synced_folder ".", "/vagrant", disabled: true
    build_stable.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_stable"],
        "stable" => ["build_stable"],
        "folio-backend" => ["build_stable"],
        "stripes" => ["build_stable"]
      }
    end
  end

  config.vm.define "build_testing", autostart: false do |build_testing|
    build_testing.vm.box = "debian/jessie64"
    build_testing.vm.network "forwarded_port", guest: 9130, host: 9130
    build_testing.vm.network "forwarded_port", guest: 3000, host: 3000
    build_testing.vm.synced_folder ".", "/vagrant", disabled: true
    build_testing.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_testing"],
        "testing" => ["build_testing"],
        "folio-backend" => ["build_testing"],
        "stripes" => ["build_testing"]
      }
    end
  end

  config.vm.define "build_testing_backend", autostart: false do |build_testing_backend|
    build_testing_backend.vm.box = "debian/jessie64"
    build_testing_backend.vm.network "forwarded_port", guest: 9130, host: 9130
    build_testing_backend.vm.synced_folder ".", "/vagrant", disabled: true
    build_testing_backend.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "vagrant" => ["build_testing_backend"],
        "testing" => ["build_testing_backend"],
        "folio-backend" => ["build_testing_backend"]
      }
    end
  end

  config.vm.define "build_curriculum", autostart: false do |build_curriculum|
    build_curriculum.vm.box = "debian/contrib-jessie64"
    build_curriculum.vm.network "forwarded_port", guest: 9130, host: 9130
    build_curriculum.vm.network "forwarded_port", guest: 3000, host: 3000
    build_curriculum.vm.synced_folder ".", "/vagrant", disabled: true
    build_curriculum.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
    end
  end
end

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

  config.vm.define "backend", autostart: false do |backend|
    backend.vm.box = "folio/folio-backend"
    backend.vm.synced_folder ".", "/vagrant", disabled: true
    backend.vm.network "forwarded_port", guest: 9130, host: 9130
  end

  config.vm.define "backend_auth", autostart: false do |backend_auth|
    backend_auth.vm.box = "folio/folio-backend-auth"
    backend_auth.vm.synced_folder ".", "/vagrant", disabled: true
    backend_auth.vm.network "forwarded_port", guest: 9130, host: 9130
  end

  config.vm.define "demo", autostart: false do |demo|
    demo.vm.box = "folio/folio-demo"
    demo.vm.synced_folder ".", "/vagrant", disabled: true
    demo.vm.network "forwarded_port", guest: 9130, host: 9130
  end

  config.vm.define "build_backend", autostart: false do |build_backend|
    build_backend.vm.box = "debian/jessie64"
    build_backend.vm.network "forwarded_port", guest: 9130, host: 9130
    build_backend.vm.synced_folder ".", "/vagrant", disabled: true
    build_backend.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "blackbox" => ["build_backend"]
      }
    end
  end

  config.vm.define "build_backend_auth", autostart: false do |build_backend_auth|
    build_backend_auth.vm.box = "debian/jessie64"
    build_backend_auth.vm.network "forwarded_port", guest: 9130, host: 9130
    build_backend_auth.vm.synced_folder ".", "/vagrant", disabled: true
    build_backend_auth.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "blackbox" => ["build_backend_auth"]
      }
    end
  end

  config.vm.define "build_demo", autostart: false do |build_demo|
    build_demo.vm.box = "debian/jessie64"
    build_demo.vm.network "forwarded_port", guest: 9130, host: 9130
    build_demo.vm.network "forwarded_port", guest: 3000, host: 3000
    build_demo.vm.synced_folder ".", "/vagrant", disabled: true
    build_demo.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
      ansible.groups = {
        "blackbox" => ["build_demo"]
      }
    end
  end

end

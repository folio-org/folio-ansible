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

  config.vm.define "dev", autostart: false do |dev|
    dev.vm.box = "debian/contrib-jessie64"
    dev.vm.network "forwarded_port", guest: 9130, host: 9130
    dev.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
    end
  end

  config.vm.define "backend", autostart: false do |backend|
    backend.vm.box = "folio-backend"
    backend.vm.box_url = "ftp://tekka.indexdata.com/pub/folio-vagrant/folio-backend.box"
    backend.vm.box_download_checksum = "ec501fde2a20fda915b811a76d8e102a"
    backend.vm.box_download_checksum_type = "md5"
    backend.vm.synced_folder ".", "/vagrant", disabled: true
    backend.vm.network "forwarded_port", guest: 9130, host: 9130
  end
    
  config.vm.define "demo", autostart: false do |demo|
    demo.vm.box = "folio-demo"
    demo.vm.box_url = "ftp://tekka.indexdata.com/pub/folio-vagrant/folio-demo.box"
    demo.vm.box_download_checksum = "ec501fde2a20fda915b811a76d8e102a"
    demo.vm.box_download_checksum_type = "md5"
    demo.vm.synced_folder ".", "/vagrant", disabled: true
    demo.vm.network "forwarded_port", guest: 9130, host: 9130
  end

  config.vm.define "build_backend", autostart: false do |build_backend|
    build_backend.vm.box = "debian/jessie64"
    build_backend.vm.network "forwarded_port", guest: 9130, host: 9130
    build_backend.vm.synced_folder ".", "/vagrant", disabled: true
    build_backend.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
    end
  end

  config.vm.define "build_demo", autostart: false do |build_demo|
    build_demo.vm.box = "debian/jessie64"
    build_demo.vm.network "forwarded_port", guest: 9130, host: 9130
    build_demo.vm.synced_folder ".", "/vagrant", disabled: true
    build_demo.vm.provision "ansible" do |ansible|
      ansible.playbook = "folio.yml"
    end
  end

end

# -*- mode: ruby -*-
# vi: set ft=ruby :
# Build a VM to serve as an Okapi/Docker server
# Deploy development environment

Vagrant.configure(2) do |config|
  # Target platform is Debian/jessie on VirtualBox
  config.vm.box = "debian/contrib-jessie64"

  # Give us a little headroom here
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end

  # Share the project folder on /vagrant (this is the default)
  config.vm.synced_folder ".", "/vagrant"


  # Set up port forwarding
  config.vm.network "forwarded_port", guest: 9130, host: 9130

  # Ansible provisioning
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "folio.yml"
    ansible.groups = {
      "dev" => ["default"],
    }
  end
end

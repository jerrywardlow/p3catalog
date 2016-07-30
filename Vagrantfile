# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    if Vagrant.has_plugin?("vagrant-hostmanager")
        config.hostmanager.enabled = True
    end
    config.vm.provision "shell", path: "provision/ic_config.sh"
    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "p3catalog"
    config.vm.network :private_network, ip: "172.22.22.234"
    config.vm.network :forwarded_port, guest: 5000, host: 5000
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder "app/", "/itemcatalog"

    config.vm.provider "virtualbox" do |vb|
        vb.name = "Item Catalog"
    end
end

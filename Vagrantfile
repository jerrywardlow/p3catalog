# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.provision "shell", path: "ic_config.sh"
  config.vm.box = "ubuntu/trusty32"
  config.vm.network "forwarded_port", guest: 5000, host: 5000
end

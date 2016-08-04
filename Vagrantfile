# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = [
  {
    hostname: "postgres",
    box: "ubuntu/trusty64",
    config: "provision/db.sh",
    ip: "192.168.56.2",
    port: 5432,
    synchost: "db/",
    syncguest: "/db"
  },
  {
    hostname: "app",
    box: "ubuntu/trusty64",
    config: "provision/ic_config.sh",
    ip: "192.168.56.3",
    port: 5000,
    synchost: "app/",
    syncguest: "/itemcatalog"
  }
]

Vagrant.configure(2) do |config|
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
  end
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.provision :shell, path: node[:config]
      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.hostname = node[:hostname]
      nodeconfig.vm.network :private_network, ip: node[:ip]
      nodeconfig.vm.network :forwarded_port, guest: node[:port], host: node[:port]
      nodeconfig.vm.synced_folder ".", "/vagrant", disabled: true
      nodeconfig.vm.synced_folder node[:synchost], node[:syncguest]

      nodeconfig.vm.provider "virtualbox" do |vb|
        vb.name = node[:hostname]
      end
    end
  end
end

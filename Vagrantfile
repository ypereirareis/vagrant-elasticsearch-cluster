# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box_url = "debian-wheezy-chef-elasticsearch-amd64-vbox.box"
  config.vm.box = "elasticsearch-cluster"
  config.vm.synced_folder ".", "/vagrant", :id => "vagrant-root", :mount_options => ["dmode=777", "fmode=777"]

  config.vm.provider "virtualbox" do |vbox|
    vbox.customize ["modifyvm", :id, "--memory", 512]
    vbox.customize ["modifyvm", :id, "--cpus", 1]
  end

  config.vm.define :vm1, primary: true do |vm1|
    vm1.vm.box = "elasticsearch-node-1"
    vm1.vm.network "private_network", ip: "10.0.0.11", auto_config: true
    vm1.vm.provision "shell" do |sh|
      sh.path = "./scripts/start-node"
      sh.args = "vm1"
    end
  end

  config.vm.define :vm2 do |vm2|
    vm2.vm.box = "elasticsearch-node-2"
    vm2.vm.network "private_network", ip: "10.0.0.12", auto_config: true
    vm2.vm.provision "shell" do |sh|
      sh.path = "./scripts/start-node"
      sh.args = "vm2"
    end
  end

  config.vm.define :vm3 do |vm3|
    vm3.vm.box = "elasticsearch-node-3"
    vm3.vm.network "private_network", ip: "10.0.0.13", auto_config: true
    vm3.vm.provision "shell" do |sh|
      sh.path = "./scripts/start-node"
      sh.args = "vm3"
    end
  end

  config.vm.define :vm4 do |vm4|
    vm4.vm.box = "elasticsearch-node-4"
    vm4.vm.network "private_network", ip: "10.0.0.14", auto_config: true
    vm4.vm.provision "shell" do |sh|
      sh.path = "./scripts/start-node"
      sh.args = "vm4"
    end
  end

  config.vm.define :vm5 do |vm5|
    vm5.vm.box = "elasticsearch-node-5"
    vm5.vm.network "private_network", ip: "10.0.0.15", auto_config: true
    vm5.vm.provision "shell" do |sh|
      sh.path = "./scripts/start-node"
      sh.args = "vm5"
    end
  end

end

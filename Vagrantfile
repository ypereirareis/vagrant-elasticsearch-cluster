# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes_number = 5

Dir.mkdir('.vagrant') unless Dir.exist?('.vagrant')
if File.exist? '.vagrant/cluster'
    nodes_number = (File.read '.vagrant/cluster').to_i 10
end

if ENV['CLUSTER_COUNT']
    nodes_number = ENV['CLUSTER_COUNT'].to_i 10
end

File.open('.vagrant/cluster','w') do |file|
    file.puts nodes_number.to_s
end

Vagrant.configure("2") do |config|

  config.vm.box = 'ypereirareis/debian-elasticsearch-amd64'
  config.vm.synced_folder ".", "/vagrant", :id => "vagrant-root", :mount_options => ["dmode=777", "fmode=777"]

  config.vm.provider "virtualbox" do |vbox|
    vbox.customize ["modifyvm", :id, "--memory", 512]
    vbox.customize ["modifyvm", :id, "--cpus", 1]
  end

  (1..nodes_number).each do |index|
      primary = (index.eql? 1)
      ip = "10.0.0.#{10 + index}"

      config.vm.define :"vm#{index}", primary: primary do |node|
          node.vm.network 'private_network', ip: ip, auto_config: true

          node.vm.provision 'shell' do |sh|
              sh.path = 'scripts/start-node'
              sh.args = "vm#{index}"
          end
      end
  end

end

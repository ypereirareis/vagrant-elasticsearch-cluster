# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'
require_relative 'lib/elasticsearch-module.rb'
require_relative 'lib/elasticsearch-script.rb'

utils = Vagrant::ElastiSearchCluster::Util.new

Vagrant.configure("2") do |config|

  utils.manage_and_print_config

  nodes_number = utils.get_cluster_info 'cluster_count'
  nodes_number = nodes_number.to_i

  cluster_ram = utils.get_cluster_info 'cluster_ram'
  cluster_ram = cluster_ram.to_i

  config.vm.box = 'ypereirareis/debian-elasticsearch-amd64'
  config.vm.synced_folder ".", "/vagrant", :id => "vagrant-root", :mount_options => ['dmode=777', 'fmode=777']

  config.vm.provider 'virtualbox' do |vbox|
    vbox.customize ['modifyvm', :id, '--memory', cluster_ram]
    vbox.customize ['modifyvm', :id, '--cpus', 1]
  end

  (1..nodes_number).each do |index|
      name = utils.get_vm_name index
      node_name = utils.get_node_name index
      ip = utils.get_vm_ip index
      primary = (index.eql? 1)

      utils.build_config index

      config.vm.define :"#{name}", primary: primary do |node|
          node.vm.hostname = "#{node_name}.es.dev"
          node.vm.network 'private_network', ip: ip, auto_config: true
          node.vm.provision 'shell', inline: @node_start_inline_script % [name, node_name, ip]
      end
  end
  utils.logger.info "----------------------------------------------------------"
end

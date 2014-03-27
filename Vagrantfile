# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'

script = <<SCRIPT
if ! cat /etc/profile | grep -q vagrant
then
    cat <<EOT >> /etc/profile.d/vagrant-elasticsearch-cluster.sh

export VM_NAME=%s
export PATH=/vagrant/scripts:/home/vagrant/elasticsearch-1.0.1/bin:\\$PATH
EOT

    sed 's#^.*secure_path="\\(.*\\)"$#Defaults secure_path="\\1:/vagrant/scripts:/home/vagrant/elasticsearch-1.0.1/bin"#' -i /etc/sudoers
    echo 'Defaults env_keep = "VM_NAME"' >> /etc/sudoers

    source /etc/profile
fi

screen -li | grep -q elastic || node-start
SCRIPT

module Vagrant
    module ElastiSearchCluster
        class Util
            attr_accessor :logger

            def initialize
                @names = %w(thor zeus isis shifu baal)
                @logger = Vagrant::UI::Colored.new
                @logger.opts[:color] = :white
            end

            def get_vm_name(index)
                "vm#{index}"
            end

            def get_vm_ip(index)
                get_ip % (10 + index)
            end

            def get_node_name(index)
                @names[index - 1]
            end

            def get_ip
                return ENV['CLUSTER_IP_PATTERN'] if ENV['CLUSTER_IP_PATTERN']
                return (File.read '.vagrant/cluster_ip') if File.exist? '.vagrant/cluster_ip'

                '10.0.0.%d'
            end

            def save_ip(pattern)
                Dir.mkdir('.vagrant') unless Dir.exist?('.vagrant')

                File.open('.vagrant/cluster_ip', 'w') do |file|
                    file.puts pattern
                end
            end

            def get_size
                return ENV['CLUSTER_COUNT'].to_i 10 if ENV['CLUSTER_COUNT']
                return (File.read '.vagrant/cluster_size').to_i 10 if File.exist? '.vagrant/cluster_size'

                5
            end

            def save_size(size)
                Dir.mkdir('.vagrant') unless Dir.exist?('.vagrant')

                File.open('.vagrant/cluster', 'w') do |file|
                    file.puts size.to_s
                end
            end

            def get_config_template
                config_file = File.open('conf/elasticsearch.yml.erb', 'r')

                ERB.new(config_file.read)
            end

            def build_config(index)
                vm = get_vm_name index

                Dir.mkdir("conf/#{vm}") unless Dir.exist?("conf/#{vm}")

                File.open("conf/#{vm}/elasticsearch.yml", 'w') do |file|
                    @node_ip = get_vm_ip index
                    @node_name = get_node_name index
                    @node_marvel_enabled = (index == 1)
                    @cluster_ip = get_ip

                    @logger.info "Building configuration for #{vm}"
                    file.puts self.get_config_template.result(binding)
                end unless File.exist? "conf/#{vm}/elasticsearch.yml"
            end
        end
    end
end

utils = Vagrant::ElastiSearchCluster::Util.new

Vagrant.configure("2") do |config|
  nodes_number = utils.get_size
  utils.logger.info "Cluster size: #{nodes_number}"
  utils.save_size nodes_number

  utils.logger.info "Cluster IP: #{utils.get_ip % 0}"
  utils.save_ip utils.get_ip

  config.vm.box = 'ypereirareis/debian-elasticsearch-amd64'
  config.vm.synced_folder ".", "/vagrant", :id => "vagrant-root", :mount_options => ['dmode=777', 'fmode=777']

  config.vm.provider 'virtualbox' do |vbox|
    vbox.customize ['modifyvm', :id, '--memory', 512]
    vbox.customize ['modifyvm', :id, '--cpus', 1]
  end

  (1..nodes_number).each do |index|
      name = utils.get_vm_name index
      primary = (index.eql? 1)
      ip = utils.get_vm_ip index

      utils.build_config index

      config.vm.define :"#{name}", primary: primary do |node|
          node.vm.network 'private_network', ip: ip, auto_config: true
          node.vm.provision 'shell', inline: script % [name]
      end
  end
end

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

                File.open('.vagrant/cluster_size', 'w') do |file|
                    file.puts size.to_s
                end
            end

            def get_config_template
                config_file = File.open('conf/elasticsearch.yml.erb', 'r')

                ERB.new(config_file.read)
            end

            def build_config(index)
                vm = get_vm_name index

                File.open("conf/elasticsearch-#{vm}.yml", 'w') do |file|
                    @node_ip = get_vm_ip index
                    @node_name = get_node_name index
                    @node_marvel_enabled = (index == 1)
                    @cluster_ip = get_ip

                    @logger.info "Building configuration for #{vm}"
                    file.puts self.get_config_template.result(binding)
                end unless File.exist? "conf/elasticsearch-#{vm}.yml"
            end
        end
    end
end


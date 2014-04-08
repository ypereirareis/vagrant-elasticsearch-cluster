module Vagrant
    module ElastiSearchCluster
        class Util
            attr_accessor :logger

            def initialize
                @params = [
                    'cluster_name' => ['CLUSTER_NAME', 'cluster_name', 'My amazing ES cluster'],
                    'cluster_ip' => ['CLUSTER_IP_PATTERN', 'cluster_ip', '10.0.0.%d'],
                    'cluster_count' => ['CLUSTER_COUNT', 'cluster_size', 5],
                    'cluster_ram' => ['CLUSTER_RAM', 'cluster_ram', 512],
                ]

                @names = %w(thor zeus isis shifu baal)
                @logger = Vagrant::UI::Colored.new
                @logger.opts[:color] = :white
            end

            def get_vm_name(index)
                "vm#{index}"
            end

            def get_vm_ip(index)
                ip = get_cluster_info 'cluster_ip'
                ip % (10 + index)
            end

            def get_node_name(index)
                @names[index - 1]
            end

            def get_cluster_info(index)
                return ENV[@params[0][index][0]] if ENV[@params[0][index][0]]
                return (File.read ".vagrant/#{@params[0][index][1]}") if File.exist? ".vagrant/#{@params[0][index][1]}"
                "#{@params[0][index][2]}"
            end

            def save_cluster_info(index, value)
                Dir.mkdir('.vagrant') unless Dir.exist?('.vagrant')
                File.open(".vagrant/#{@params[0][index][1]}", 'w') do |file|
                    file.puts value.to_s
                end
            end

            def get_config_template
                config_file = File.open('conf/elasticsearch.yml.erb', 'r')
                ERB.new(config_file.read)
            end

            def build_config(index)
                vm = get_vm_name index
                conf_file_format = "conf/elasticsearch-#{vm}.yml"

                File.open(conf_file_format, 'w') do |file|
                    @node_ip = get_vm_ip index
                    @node_name = get_node_name index
                    @node_marvel_enabled = (index == 1)
                    @cluster_ip = get_cluster_info 'cluster_ip'
                    @cluster_name = get_cluster_info 'cluster_name'

                    @logger.info "Building configuration for #{vm}"
                    file.puts self.get_config_template.result(binding)
                end unless File.exist? conf_file_format
            end

            def manage_and_print_config
                self.logger.info "----------------------------------------------------------"
                self.logger.info "          Your ES cluster configurations"
                self.logger.info "----------------------------------------------------------"

                # Building and showing CLUSTER NAME information
                index = 'cluster_name'
                cluster_name = self.get_cluster_info index
                self.logger.info "Cluster Name: #{cluster_name.strip}"
                self.save_cluster_info index, cluster_name

                # Building and showing CLUSTER COUNT information
                index = 'cluster_count'
                nodes_number = self.get_cluster_info index
                self.logger.info "Cluster size: #{nodes_number.strip}"
                self.save_cluster_info index, nodes_number

                # Building and showing CLUSTER IP PATTERN information
                index = 'cluster_ip'
                cluster_network_ip = self.get_cluster_info index
                self.logger.info "Cluster network IP: #{cluster_network_ip.strip % 0}"
                self.save_cluster_info index, cluster_network_ip

                # Building and showing CLUSTER RAM information
                index = 'cluster_ram'
                cluster_ram = self.get_cluster_info index
                self.logger.info "Cluster RAM (for each node): #{cluster_ram.strip}"
                self.save_cluster_info index, cluster_ram

                self.logger.info "----------------------------------------------------------"
            end
        end
    end
end


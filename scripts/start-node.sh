
VM_NAME=$1
screen -d -m /home/vagrant/elasticsearch-1.0.1/bin/elasticsearch -Des.config=/vagrant/conf/$VM_NAME/elasticsearch.yml

vagrant-elasticsearch-cluster
=============================

Create an ElasticSearch cluster with a single bash command

Installation
--

git clone git@github.com:ypereirareis/vagrant-elasticsearch-cluster.git

Requirements
--

* VirtualBox (last version)
* Vagrant (last version)


**WARNING**

You'll need enough RAM to run VMs in your cluster.
Each new VM launched within your cluster will have 512M of RAM allocated.  
You can change this configuration in the Vagrantfile once cloned.  

Configure your cluster
--

If you need or want to change the default working configuration of your cluster,
you can do it editing elasticsearch.yml files in conf/vmX/elasticsearch.yml.
Each node configuration is shared with VM thanks to this "conf" directory.

ElasticSearch plugins installed inside the base box
--

* elasticsearch-head - [https://github.com/mobz/elasticsearch-head](https://github.com/mobz/elasticsearch-head)
* elasticsearch-paramedic - [https://github.com/karmi/elasticsearch-paramedic](https://github.com/karmi/elasticsearch-paramedic)
* BigDesk - [https://github.com/lukas-vlcek/bigdesk](https://github.com/lukas-vlcek/bigdesk)
* Marvel - [http://www.elasticsearch.org/overview/marvel/](http://www.elasticsearch.org/overview/marvel/)
* ElasticsearchHQ - [http://www.elastichq.org/](http://www.elastichq.org/)

How to run a new ElasticSearch cluster
--

**Important**

The maximum number VMs running in the cluster is 5.
Indeed, it would be possible to run much more than 5, but it's not really needed for a test environment cluster,
and the RAM needed would be much more important.

**Run the cluster**

Simply go in the cloned directory (vagrant-elasticsearch-cluster by default).  
Execute this command :

```
./scripts/vagrant-elasticsearch-cluster run N (N>=1, N<=5)
```

Actually execute a loop of "vagrant up" command.
ElasticSearch instance is started during provisioning of the VM.
The command is launched into a new screen as root inside the vagrant.

File : scripts/start-node.sh

```
VM_NAME=$1
screen -d -m /home/vagrant/elasticsearch-1.0.1/bin/elasticsearch -Des.config=/vagrant/conf/$VM_NAME/elasticsearch.yml
```

Once the cluster is launched go to [http://10.0.0.11:9200](http://10.0.0.11:9200)
Plugins URLs :

* [http://10.0.0.11:9200/_plugin/marvel](http://10.0.0.11:9200/_plugin/marvel)
* [http://10.0.0.11:9200/_plugin/paramedic/](http://10.0.0.11:9200/_plugin/paramedic/)
* [http://10.0.0.11:9200/_plugin/head/](http://10.0.0.11:9200/_plugin/head/)
* [http://10.0.0.11:9200/_plugin/bigdesk](http://10.0.0.11:9200/_plugin/bigdesk)
* [http://10.0.0.11:9200/_plugin/HQ/](http://10.0.0.11:9200/_plugin/HQ/)


**Stop the cluster**

```
./scripts/vagrant-elasticsearch-cluster stop
```

Actually execute a loop of "vagrant halt" command.

**Destroy the cluster**

```
./scripts/vagrant-elasticsearch-cluster destroy
```

Actually execute a loop of "vagrant destroy" command.

**Remove the cluster**

```
./scripts/vagrant-elasticsearch-cluster remove
```

Actually execute a loop of "vagrant box remove" command.
vagrant-elasticsearch-cluster
=============================

Create an ElasticSearch cluster with a single bash command

**Program and versions information**

| program         | version       |
| --------------- | ------------- |
| ElasticSearch   | 1.0.1         |
| Java            | openjdk-7-jre |


**Cluster simple configuration**

| Configuration      |  Value(s)                                            |
| ------------------ | ---------------------------------------------------- |
| Cluster name       | elasticsearch-cluster-test                           |
| Nodes names        | thor, zeus, isis, baal, shifu                        |
| VM names           | vm1, vm2, vm3, vm4, vm5                              |


1.Installation
--

git clone git@github.com:ypereirareis/vagrant-elasticsearch-cluster.git

2.Requirements
--

* VirtualBox (last version)
* Vagrant (>=1.5)
* cUrl


**WARNING**

You'll need enough RAM to run VMs in your cluster.
Each new VM launched within your cluster will have 512M of RAM allocated.  
You can change this configuration in the Vagrantfile once cloned.  

3.Configure your cluster
--

If you need or want to change the default working configuration of your cluster,
you can do it editing elasticsearch.yml files in conf/vmX/elasticsearch.yml.
Each node configuration is shared with VM thanks to this "conf" directory.

4.ElasticSearch plugins inside the base box
--

* elasticsearch-head - [https://github.com/mobz/elasticsearch-head](https://github.com/mobz/elasticsearch-head)
* elasticsearch-paramedic - [https://github.com/karmi/elasticsearch-paramedic](https://github.com/karmi/elasticsearch-paramedic)
* BigDesk - [https://github.com/lukas-vlcek/bigdesk](https://github.com/lukas-vlcek/bigdesk)
* Marvel - [http://www.elasticsearch.org/overview/marvel/](http://www.elasticsearch.org/overview/marvel/)
* ElasticsearchHQ - [http://www.elastichq.org/](http://www.elastichq.org/)

5.How to run a new ElasticSearch cluster
--

**Important**

The maximum number VMs running in the cluster is 5.
Indeed, it is possible to run much more than 5, but it's not really needed for a test environment cluster,
and the RAM needed would be much more important.
If you still want to use more than 5 VMs, you will have to add your own configuration files in the [conf](conf) directory.

**Run the cluster**

Simply go in the cloned directory (vagrant-elasticsearch-cluster by default).  
Execute this command :

```
vagrant up
```

By default, this command will boot 5 VMs. You can change the cluster size with the `CLUSTER_COUNT` variable:

```
CLUSTER_COUNT=3 vagrant up
```

Providing the `CLUSTER_COUNT` variable is only required when your first start the cluster. Vagrant will save this
value so you can run other commands without repeating yourself.

The names of the VMs will follow the following pattern: `vm[0-9]+`.
The trailing number represents the index of the VM, starting at 1.

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
vagrant halt
```

This will stop the whole cluster. If you want to only stop one VM, you can use:

```
vagrant halt vm2
```

This will stop the `vm2` instance.

**Destroy the cluster**

```
vagrant destroy
```

This will stop the whole cluster. If you want to only stop one VM, you can use:

```
vagrant destroy vm2
```

**Remove the cluster**

```
vagrant box remove ypereirareis/debian-elasticsearch-amd64
```

This will remove your local copy of the vagrant base-box.


**Debug ElasticSearch instances**

Each VM has its own ElasticSearch instance running in a `screen` session named `elastic`. You can reattach this session at will using:

```sh
vagrant ssh vm1

sudo screen -rx elastic
```

You should be brought to the screen session hosting ElasticSearch and see its log.

6.Working with your cluster
--

**Create a "subscriptions" index with 5 shards and 2 replicas**

```
curl -XPUT 'http://10.0.0.11:9200/subscriptions/' -d '{
    "settings" : {
        "number_of_shards" : 5,
        "number_of_replicas" : 2
    }
}'
```

**Index a "subscription" document inside the "subscriptions" index**

```
curl -XPUT 'http://10.0.0.11:9200/subscriptions/subscription/1' -d '{
    "user" : "ypereirareis",
    "post_date" : "2014-03-26T14:12:12",
    "message" : "Trying out vagrant elasticsearch cluster"
}'
```

You can now perform any action/request authorized by elasticsearch API (index, get, delete, bulk,...)

7.Vagrant
--

You can use every vagrant command to manage your cluster and VMs.
This project is simply made to launch a working elasticsearch cluster with a single command, using vagrant/virtualbox virtual machines.

Use it to test every configuration/queries you want (split brain, unicast, recovery, indexing, sharding)

8.Important
--

Do forks, PR, and MRs !!!!

9.TODO
--

* Adding data to test/execute queries (fuzzy, percolation, aggregations,...)
* Adding extra plugins or applications (redis, logstash, kibana, ...)
* Adding some configurations to illustrate split brain, unicast discovery, load balancing, snapshots,...
* Sharing log configuration file just like elasticsearch.yml
* Add a bash command to stop a specific node in the cluster
* Add a bash command to add a new node in the cluster
* Add a bash command to restart a specicif node
* Add something to simulate a network failure to see what happens with nodes and cluster state
* Add multiple nodes on the same VM to illustrate Rack configuration (shards/replicas on different "physical/virtual" machine)
* Add existing contributors rivers (twitter, wikipédia, rss, ...)

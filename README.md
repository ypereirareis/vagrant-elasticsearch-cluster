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

You'll need RAM to run VMs in your cluster.  
Each new VM launched within your cluster will have 512M of RAM allocated.  
You can change this configuration in the Vagrantfile once cloned.  

Configure your cluster
--

If you need or want to change the default working configuration of your cluster,
you can do it editing elasticsearch.yml files in conf/vmX/elasticsearch.yml.
Each node configuration is shared with VM thanks to this "conf" directory.

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

Actually executes a loop of "vagrant up" command.

**Stop the cluster**

```
./scripts/vagrant-elasticsearch-cluster stop
```

Actually executes a loop of "vagrant halt" command.

**Destroy the cluster**

```
./scripts/vagrant-elasticsearch-cluster destroy
```

Actually executes a loop of "vagrant destroy" command.

**Remove the cluster**

```
./scripts/vagrant-elasticsearch-cluster remove
```

Actually executes a loop of "vagrant box remove" command.
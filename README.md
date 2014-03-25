vagrant-elasticsearch-cluster
=============================

Create an ElasticSearch cluster with a simple single bash command

Installation : how to get these files
--

git clone git@github.com:ypereirareis/vagrant-elasticsearch-cluster.git

Requirements : needed to run the cluster
--

* VirtualBox (last version)
* Vagrant (last version)
* NFS (optional)

**WARNING**

You'll need RAM to run VMs in your cluster.
Each new VM launched within your cluster will have 512M of RAM allocated.
You can change this configuration in the Vagrantfile once cloned.

Running : how to run a new ElasticSearch cluster
--

**Important**

The maximum number VM running in the cluster is 5.
Indeed, it would be possible to run more than 5, but it's not really needed for an test environment cluster,
and the RAM needed would be much more important.

**Runing the cluster**

Simply go in the cloned directory (vagrant-elasticsearch-cluster by default).
Execute this command : vagrant-elasticsearch-cluster run N (N>=1, N<=5)


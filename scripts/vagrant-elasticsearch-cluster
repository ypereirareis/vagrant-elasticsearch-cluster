
# Max VMs a user can launch
CLUSTER_COUNT_MAX="5"

# Action user want to do
CLUSTER_ACTION=$1

# How many VMs the user want to launch
CLUSTER_COUNT=$2


# ----------------------------------------------------------
# Maximum running VM is 5 (CLUSTER_COUNT_MAX)
# ----------------------------------------------------------
[[ -z "$CLUSTER_COUNT" ]] || [ $CLUSTER_COUNT -le $CLUSTER_COUNT_MAX ] || CLUSTER_COUNT="$CLUSTER_COUNT_MAX"

# ----------------------------------------------------------
# Starts $CLUSTER_COUNT VMs when running the cluster
# ----------------------------------------------------------
if [ $CLUSTER_ACTION == "run" ]
then
  i="1"

  while [ $i -le $CLUSTER_COUNT ]
  do
    echo "-------------------------------"
    echo "  Starting vagrant \"vm${i}\""
    echo "-------------------------------"
    vagrant up vm${i}
    [ $? -eq 0 ] || exit
    i=$[$i+1]
  done
fi


# ----------------------------------------------------------
# Halts $CLUSTER_COUNT_MAX VMs when stopping the cluster
# ----------------------------------------------------------
if [ $CLUSTER_ACTION == "stop" ]
then
  i="1"

  while [ $i -le $CLUSTER_COUNT_MAX ]
  do
    echo "-------------------------------"
    echo "  Stoping vagrant \"vm${i}\""
    echo "-------------------------------"
    vagrant halt vm${i}
    [ $? -eq 0 ] || exit
    i=$[$i+1]
  done
fi

# ----------------------------------------------------------
# Destroy $CLUSTER_COUNT_MAX VMs when destroying the cluster
# ----------------------------------------------------------
if [ $CLUSTER_ACTION == "destroy" ]
then
  i="1"

  while [ $i -le $CLUSTER_COUNT_MAX ]
  do
    echo "-------------------------------"
    echo "  Destroying vagrant \"vm${i}\""
    echo "-------------------------------"
    vagrant destroy vm${i} -f
    [ $? -eq 0 ] || exit
    i=$[$i+1]
  done
fi

# ----------------------------------------------------------
# Remove $CLUSTER_COUNT_MAX VMs boxes
# ----------------------------------------------------------
if [ $CLUSTER_ACTION == "remove" ]
then
  i="1"

  while [ $i -le $CLUSTER_COUNT_MAX ]
  do
    echo "-------------------------------"
    echo "  Removing box \"elasticsearch-node-${i}\""
    echo "-------------------------------"
    vagrant box remove elasticsearch-node-${i}
    i=$[$i+1]
  done
fi


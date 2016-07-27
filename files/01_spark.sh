#!/bin/bash

if [ "$NODE_TYPE" = "master" ]; then
  $SPARK_HOME/sbin/start-master.sh
elif [ "$NODE_TYPE" = "slave" ]; then
  export SPARK_LOCAL_IP=$(ip addr list $SPARK_NETWORK_NIC | grep 'inet ' | cut -d' ' -f6 | cut -d/ -f1)
  export SPARK_PUBLIC_DNS=$SPARK_LOCAL_IP
  $SPARK_HOME/sbin/start-slave.sh spark://$SPARK_MASTER_IP:7077
else
  echo 'Please set NODE_TYPE=[master|slave]'
  exit 1
fi && \
tail -f $SPARK_HOME/logs/spark--org.apache.spark.deploy.*.out


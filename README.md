Docker container for Apache Spark
==========

[![DockerPulls](https://img.shields.io/docker/pulls/scalac/spark.svg)](https://registry.hub.docker.com/r/scalac/spark/)
[![DockerStars](https://img.shields.io/docker/stars/scalac/spark.svg)](https://registry.hub.docker.com/r/scalac/spark/)

This repository contains a Docker file and Docker Compose file to build and run a Docker image with Apache Spark.

## Pull the image from Docker Repository

```
docker pull scalac/spark:latest
```

## Building the image

```
docker build --rm -t scalac/spark:latest .
```

## Running the image

```bash
export SPARK_NETWORK_NIC=eth0        # must be the same on all nodes
export SPARK_MASTER_IP=192.168.1.11  # must be accessable from all worker nodes


# start master
docker run -d -P \
  -e NODE_TYPE=master \
  -e SPARK_MASTER_IP=$SPARK_MASTER_IP \
  -e constraint:spark.role==master \
  -p 6066:6066 \
  -p 7077:7077 \
  -p 8080:8080 \
  -p 8081:8081 \
  --name spark-master \
  --net host \
  --restart unless-stopped \
  scalac/spark:latest

# start workers
for i in `seq 1 $(docker info 2>/dev/null | grep spark.role=worker | wc -l)`; do \
  docker run -d -P \
    -e NODE_TYPE=slave \
    -e SPARK_NETWORK_NIC=$SPARK_NETWORK_NIC \
    -e SPARK_MASTER_IP=$SPARK_MASTER_IP \
    -p 8081:8081 \
    --name spark_worker_$i \
    --net host \
    --restart unless-stopped \
    scalac/spark:latest; \
done

# run test job
docker exec -it spark-master /opt/spark/bin/spark-submit --class org.apache.spark.examples.SparkPi \
  --master spark://$SPARK_MASTER_IP:6066 \
  --deploy-mode cluster \
  --driver-memory 1g \
  --executor-memory 1g \
  --executor-cores 1 \
  --queue thequeue \
  "/opt/spark/lib/spark-examples-1.6.2-hadoop2.6.0.jar" \
  10
```

## Running with Docker Compose

This deployment is using `constraints` to enforce that spark-master is always started on desired node.
Your master node should be tagged `spark.role="master" and workers "spark.role=worker".

```bash
export SPARK_NETWORK_NIC=eth0        # must be the same on all nodes
export SPARK_MASTER_IP=192.168.1.11  # must be accessable from all worker nodes

docker-compose up -d
docker scale worker=$(docker info 2>/dev/null | grep spark.role=worker | wc -l')
```

## Versions

```
Java 1.8
Apache Spark 1.6.2
Hadoop 2.6.0
```

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

```
docker run -it -P -h spark-master -e NODE_TYPE=master scalac/spark:latest
docker run -it -P -h spark-master -e NODE_TYPE=slave scalac/spark:latest
```

## Running with Docker Compose

```
docker-compose up -d
docker scale worker=4
```

## Versions

```
Java 1.8
Apache Spark 1.6.1
Hadoop 2.6.0
```

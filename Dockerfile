FROM scalac/java8:latest

MAINTAINER Jakub Zubielik <jakub.zubielik@scalac.io>

ENV SPARK_VERSION  1.6.2
ENV HADOOP_VERSION 2.6
ENV SPARK_HOME     /opt/spark

RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | tar -xz -C /opt

RUN cd /opt && ln -s spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

ADD files/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

ADD files/01_spark.sh /etc/my_init.d/01_spark.sh

RUN chmod +x /etc/my_init.d/01_spark.sh

RUN mkdir -p /data/spark-events

EXPOSE 4040 7001 7002 7003 7004 7005 7006 7077 8080 8081 18080

CMD ["/sbin/my_init"]

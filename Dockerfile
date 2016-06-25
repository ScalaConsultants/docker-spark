FROM scalac/java8:latest

MAINTAINER Jakub Zubielik <jakub.zubielik@scalac.io>

ENV SPARK_VERSION  1.6.1
ENV HADOOP_VERSION 2.6
ENV SPARK_HOME     /opt/spark

RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | tar -xz -C /opt

RUN cd /opt && ln -s spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

RUN echo '\
spark.broadcast.factory         org.apache.spark.broadcast.HttpBroadcastFactory\n\
spark.ui.port                   4040\n\
spark.driver.port               7001\n\
spark.fileserver.port           7002\n\
spark.broadcast.port            7003\n\
spark.replClassServer.port      7004\n\
spark.blockManager.port         7005\n\
spark.executor.port             7006' \
> $SPARK_HOME/conf/spark-defaults.conf

RUN echo "#!/bin/bash\n\
export LOCAL_IP=\$(ip addr list eth0 |grep 'inet ' |cut -d' ' -f6|cut -d/ -f1)\n\
if [ \"\$NODE_TYPE\" = \"master\" ]; then\n\
  \$SPARK_HOME/sbin/start-master.sh -i \$LOCAL_IP\n\
elif [ \"\$NODE_TYPE\" = \"slave\" ]; then\n\
  \$SPARK_HOME/sbin/start-slave.sh -i \$LOCAL_IP spark://spark-master:7077\n\
else\n\
  echo 'Please set NODE_TYPE=[master|slave]'\n\
  exit 1\n\
fi\n\
tail -f \$SPARK_HOME/logs/spark--org.apache.spark.deploy.*.out" \
> /etc/my_init.d/01_spark.sh

RUN chmod +x /etc/my_init.d/01_spark.sh

EXPOSE 4040 7001 7002 7003 7004 7005 7006 7077 8080 8081 8888

CMD ["/sbin/my_init"]

#!/bin/bash

__HDP_HADOOP_BIN__/hdfs namenode -format -force
__HDP_HADOOP_SBIN__/hadoop-daemon.sh --config __HADOOP_CONF_DIR__ start namenode
__HDP_HADOOP_SBIN__/hadoop-daemon.sh --config __HADOOP_CONF_DIR__ start datanode

# Create HBASE related folders here
(
hdfs dfs -mkdir -p /apps/hbase/staging /apps/hbase/data

hdfs dfs -chown hbase:hdfs /apps/hbase/staging /apps/hbase/data
hdfs dfs -chmod 711 /apps/hbase/staging
hdfs dfs -chmod 755 /apps/hbase/data

hdfs dfs -chown hdfs:hdfs /apps/hbase
) &

hdfs dfs -mkdir -p /hdp/apps/__HDP_VERSION__/mapreduce/
hdfs dfs -put __HDP_CURRENT_FOLDER__/hadoop-client/mapreduce.tar.gz /hdp/apps/__HDP_VERSION__/mapreduce/
hdfs dfs -chown -R __HDFS_USER__:__HADOOP_GROUP__ /hdp
hdfs dfs -chmod -R 555 /hdp/apps/__HDP_VERSION__/mapreduce
hdfs dfs -chmod 444 /hdp/apps/__HDP_VERSION__/mapreduce/mapreduce.tar.gz

# We will try to set up general CDAP related stuff (cluster-prep) here 
(
hdfs dfs -mkdir -p /user/yarn 
hdfs dfs -chown yarn:yarn /user/yarn 

hdfs dfs -mkdir -p /cdap 
hdfs dfs -chown yarn /cdap

hdfs dfs -mkdir -p /cdap/tx.snapshot 
hdfs dfs -chown yarn /cdap/tx.snapshot
) &

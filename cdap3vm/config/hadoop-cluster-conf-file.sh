#!/bin/sh

#
# Based on HortonWorks Directories Script
#

# __HDP_VERSION__=2.3.2.0-2950
__HDP_VERSION__=2.4.3.0-227
# Space separated list of directories where NameNode will store file system image. 
# For example, /grid/hadoop/hdfs/nn /grid1/hadoop/hdfs/nn
__DFS_NAME_DIR__=/opt/data/hadoop/hdfs/namenode

# Space separated list of directories where DataNodes will store the blocks. 
# For example, /grid/hadoop/hdfs/dn /grid1/hadoop/hdfs/dn /grid2/hadoop/hdfs/dn
__DFS_DATA_DIR__=/opt/data/hadoop/hdfs/data

# Space separated list of directories where SecondaryNameNode will store checkpoint image. 
# For example, /grid/hadoop/hdfs/snn /grid1/hadoop/hdfs/snn /grid2/hadoop/hdfs/snn
__FS_CHECKPOINT_DIR__=/opt/data/hadoop/hdfs/snamenode

# Directory to store the HDFS logs.
__HDFS_LOG_DIR__=/opt/data/log/hadoop/hdfs

# Directory to store the HDFS process ID.
__HDFS_PID_DIR__=/var/run/hadoop/hdfs

# Directory to store the Hadoop configuration files.
__HADOOP_CONF_DIR__=/etc/hadoop/conf

# Main Hadoop LOG dir
__HADOOP_LOG_MAIN_DIR__=/opt/data/log

#
# Hadoop Service - YARN 
#

# Space separated list of directories where YARN will store temporary data. 
# For example, /grid/hadoop/yarn/local /grid1/hadoop/yarn/local /grid2/hadoop/yarn/local
__YARN_LOCAL_DIR__=/opt/data/hadoop/yarn/local

# Directory to store the YARN logs.
__YARN_LOG_DIR__=/opt/data/log/hadoop/yarn 

# Directory for nodemanager.recovery
__YARN_NODEMANAGER_RECOVERY_DIR__=/opt/data/log/hadoop-yarn/nodemanager/recovery-state 


# Space separated list of directories where YARN will store container log data. 
# For example, /grid/hadoop/yarn/logs /grid1/hadoop/yarn/logs /grid2/hadoop/yarn/logs
__YARN_LOCAL_LOG_DIR__=/opt/data/hadoop/yarn/log

# Directory to store the YARN process ID.
__YARN_PID_DIR__=/var/run/hadoop/yarn

#
# Hadoop Service - MAPREDUCE
#

# Directory to store the MapReduce daemon logs.
__MAPRED_LOG_DIR__=/opt/data/log/mapred

# Directory to store the mapreduce jobhistory process ID.
__MAPRED_PID_DIR__=/var/run/hadoop/mapred

#
# Hadoop Service - HBase
#

# Directory to store the HBase configuration files.
__HBASE_CONF_DIR__=/etc/hbase/conf

# Directory to store the HBase logs.
__HBASE_LOG_DIR__=/opt/data/log/hbase

# Directory to store the HBase logs.
__HBASE_PID_DIR__=/var/run/hbase

#
# Hadoop Service - ZooKeeper
#

# Directory where ZooKeeper will store data. For example, /grid1/hadoop/zookeeper/data
__ZOOKEEPER_DATA_DIR__=/opt/data/hadoop/zookeeper/data

# Directory to store the ZooKeeper configuration files.
__ZOOKEEPER_CONF_DIR__=/etc/zookeeper/conf

# Directory to store the ZooKeeper logs.
__ZOOKEEPER_LOG_DIR__=/opt/data/log/zookeeper
__ZKFC_LOG_DIR__=/opt/data/log/hdfs

# Directory to store the ZooKeeper process ID.
__ZOOKEEPER_PID_DIR__=/var/run/zookeeper


# 
# User Accounts
#

__SUPER_USER__=root
__HADOOP_USER__=hadoop
__HDFS_USER__=hdfs
__YARN_USER__=yarn
__HBASE_USER__=hbase
__CDAP_USER__=cdap
__ZOOKEEPER_USER__=zookeeper
__MAPRED_USER__=mapred
__HADOOP_GROUP__=hadoop

#
# Other service folder locations
#
__SERVICE_CONFIG_FOLDER__=/etc/hadoop/service_scripts
__HDP_CURRENT_FOLDER__=/usr/hdp/current
__HDP_HADOOP_BIN__=/usr/hdp/current/hadoop-client/bin
__HDP_HADOOP_SBIN__=/usr/hdp/current/hadoop-client/sbin
__RPM_FOLDER_LOCATION__=pkgs

# __RPM_FOLDER_LOCATION__ is relative to main package directory
__HDP_RPM_ROOT__=UNUSED
__CDAP_RPM_ROOT__=UNUSED
__CENTOS7_RPM_ROOT__=UNUSED
#
# Main System
#
__JAVA_HOME__=/opt/app/java/jdk/jdk170
__CDAP_CONF_DIR__=/etc/cdap/conf
__CDAP_INST_FOLDER__=/opt/cdap
__NODEJS_BIN__=/opt/app/nodejs/bin



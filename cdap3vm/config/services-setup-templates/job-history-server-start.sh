#!/bin/bash

# [173931] Start MapReduce History Server during Hadoop install

__HDP_CURRENT_FOLDER__/hadoop-mapreduce-historyserver/sbin/mr-jobhistory-daemon.sh --config __HADOOP_CONF_DIR__ start historyserver
 

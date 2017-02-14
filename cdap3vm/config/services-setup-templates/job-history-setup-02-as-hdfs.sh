#!/bin/bash

hdfs dfs -mkdir -p /mr-history/tmp 
hdfs dfs -chmod -R 1777 /mr-history/tmp 

hdfs dfs -mkdir -p /mr-history/done 
hdfs dfs -chmod -R 1777 /mr-history/done
hdfs dfs -chown -R __MAPRED_USER__:__HDFS_USER__ /mr-history

hdfs dfs -mkdir -p /app-logs
hdfs dfs -chmod -R 1777 /app-logs

hdfs dfs -chown __YARN_USER__:__HDFS_USER__  /app-logs


 

#!/bin/bash

# ============LICENSE_START==========================================
# ===================================================================
# Copyright © 2017 AT&T Intellectual Property. All rights reserved.
# ===================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END============================================
# ECOMP and OpenECOMP are trademarks and service marks of AT&T Intellectual Property.

# Create user accounts for CDAP-Hadoop (3VM minimal) solution
# one argument after DESC creates a user x1:x1
# additional "other-groups" argument creates a user x1:x1 -G y1,y2,...
# additional groups have to be specified in a comma-separated format without spaces

while read desc user othergrouplist; do
  if [ -z "${othergrouplist}" ]; then
     useradd $user -m
  else 
     useradd $user -m 
     usermod -a -G ${othergrouplist} $user
  fi
done << __EOF__
HADOOP hadoop 
HDFS hdfs hadoop 
HBase hbase hadoop
YARN yarn hadoop
MapReduce mapred hadoop
ZooKeeper zookeeper hadoop
CDAP cdap
DCAE dcae hdfs
__EOF__


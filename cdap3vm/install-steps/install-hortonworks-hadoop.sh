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

export JAVA_HOME=/opt/app/java/jdk/jdk170

## Configure apt-get repo for HortonWorks:
#
echo "Configuring HortonWorks apt-get repo..."
sudo wget http://public-repo-1.hortonworks.com/HDP/ubuntu14/2.x/updates/2.4.3.0/hdp.list -O /etc/apt/sources.list.d/hdp.list

## Add the BigTop Public GPG Key:
#
# echo "Adding the HortonWorks public GPG key to apt..."
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 07513CAD

## Update apt cache:
#
echo "apt-get update..."
sudo apt-get -y update

## List Hadoop packages:
#
sudo apt-cache search hadoop
sudo apt-cache search hbase
sudo apt-cache search zookeeper

## Install HortonWorks Hadoop packages:
#
# sudo JAVA_HOME=/opt/app/java/jdk/jdk170 apt-get install hadoop\*

# sudo JAVA_HOME=/opt/app/java/jdk/jdk170 apt-get --print-uris install \

sudo JAVA_HOME=/opt/app/java/jdk/jdk170 apt-get -y install \
     hadoop hadoop-client hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-namenode \
     hadoop-hdfs-zkfc hadoop-mapreduce hadoop-mapreduce-historyserver \
     hadoop-yarn hadoop-yarn-nodemanager \
     hbase hbase-master hbase-regionserver \
     zookeeper libhdfs0

## Fix file permissions for domain sockets
#
sudo chown hdfs:hadoop /var/lib/hadoop-hdfs
sudo chown mapred:hadoop /var/lib/hadoop-mapreduce
sudo chown yarn:hadoop /var/lib/hadoop-yarn
sudo chmod 775 /var/lib/hadoop-mapreduce


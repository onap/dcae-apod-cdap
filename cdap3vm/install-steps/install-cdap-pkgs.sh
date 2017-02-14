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
PATH=$JAVA_HOME/bin:$PATH

## Assumption: Hadoop is already installed and configured
#
# hdfs.namespace is /cdap and the default property hdfs.user is yarn
#
sudo su hdfs -c "JAVA_HOME=/opt/app/java/jdk/jdk170 hadoop fs -mkdir -p /cdap && hadoop fs -chown yarn /cdap"

# create a tx.snapshot subdirectory
#
sudo su hdfs -c "JAVA_HOME=/opt/app/java/jdk/jdk170 hadoop fs -mkdir -p /cdap/tx.snapshot && hadoop fs -chown yarn /cdap/tx.snapshot"

## Configure apt-get repo for CDAP 3.5.x:
#
echo "Configuring CDAP 3.5 apt-get repo..."
sudo wget -O /etc/apt/sources.list.d/cask.list http://repository.cask.co/ubuntu/precise/amd64/cdap/3.5/cask.list

## Add the Cask Public GPG Key:
#
echo "Adding the Cask public GPG key to apt..."
wget -O - http://repository.cask.co/ubuntu/precise/amd64/cdap/3.5/pubkey.gpg | sudo apt-key add -

## Update apt cache:
#
echo "apt-get update..."
sudo apt-get -y update

## Install CDAP packages:
echo "installing cdap packages..."
sudo JAVA_HOME=/opt/app/java/jdk/jdk170 apt-get -y install cdap-gateway cdap-kafka cdap-master cdap-security cdap-ui cdap-cli

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

# [DE248724] Hadoop /var/run PID directories not persisted between
#            reboots
# Ubuntu 14 does not actually use /usr/lib/tmpfs.d, so need to
# handle creating PID dirs in init scripts.

# zookeeper:
sudo mkdir -p -m0755 /var/run/zookeeper
sudo chown zookeeper:hadoop /var/run/zookeeper

# hbase:
sudo mkdir -p -m0750 /var/run/hbase
sudo chown hbase:hadoop /var/run/hbase

# hdfs:
sudo mkdir -p -m0755 /var/run/hadoop/hdfs
sudo chown hdfs:hadoop /var/run/hadoop/hdfs

# yarn:
sudo mkdir -p -m0755 /var/run/hadoop/yarn
sudo chown yarn:hadoop /var/run/hadoop/yarn
sudo mkdir -p -m0755 /var/run/hadoop/yarn/yarn
sudo chown yarn:hadoop /var/run/hadoop/yarn/yarn

# mapred:
sudo mkdir -p -m0755 /var/run/hadoop/mapred
sudo chown mapred:hadoop /var/run/hadoop/mapred

# mapreduce:
sudo mkdir -p -m0755 /var/run/hadoop/mapreduce
sudo chown mapred:hadoop /var/run/hadoop/mapreduce

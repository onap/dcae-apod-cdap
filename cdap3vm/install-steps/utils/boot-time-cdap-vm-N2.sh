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

# Customization for this node -- after generic node is processed

MAINDIR=/etc/hadoop/service_scripts/

\. $MAINDIR/utility-scripts.sh

bash $MAINDIR/zookeeper.sh start
bash $MAINDIR/datanode.sh  
bash $MAINDIR/node-manager.sh  

wait_for_hbase_shell_OK
bash $MAINDIR/hbase-regionserver.sh  
bash $MAINDIR/cdap.sh  

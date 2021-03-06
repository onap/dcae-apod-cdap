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

MAINDIR=__SERVICE_CONFIG_FOLDER__

\. $MAINDIR/utility-scripts.sh

# set umask expected for log creation
umask 0022

ACTION="$1"

case "$ACTION" in
  start )
    # [DE248724] Hadoop /var/run PID directories
    bash $MAINDIR/create_pid_dirs.sh
    bash $MAINDIR/zookeeper.sh $ACTION
    bash $MAINDIR/datanode.sh $ACTION
    # [DE248720] start namenode on 00
    bash $MAINDIR/namenode.sh $ACTION
    bash $MAINDIR/node-manager.sh $ACTION

    wait_for_hbase_shell_OK
    bash $MAINDIR/hbase-regionserver.sh $ACTION ;;
  stop )
    bash $MAINDIR/hbase-regionserver.sh $ACTION
    bash $MAINDIR/node-manager.sh $ACTION 
    # [DE256148] stop namenode on 00
    bash $MAINDIR/namenode.sh $ACTION
    bash $MAINDIR/datanode.sh $ACTION 
    bash $MAINDIR/zookeeper.sh $ACTION ;;
  * )
    echo "Usage: $0 <start|stop>"
    exit -1 ;;
esac

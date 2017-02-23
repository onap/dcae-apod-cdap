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

# Yarn Node Manager

ACTION="$1"

case "$ACTION" in
  start|stop )
    su __YARN_USER__ -c "__HDP_CURRENT_FOLDER__/hadoop-yarn-resourcemanager/sbin/yarn-daemon.sh --config __HADOOP_CONF_DIR__ $ACTION nodemanager" ;;
  * )
    echo "Usage: $0 <start|stop>"
    exit -1 ;;
esac
 
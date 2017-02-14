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

\. ../config/main-conf.sh
\. ./utils/folder-creation-utils.sh

HADOOP_SERVICE_SETUP_FOLDER=../pkgs/services-setup

NODETYPE=N$(get_cdap_host_id)
NODETYPE=${1:-$NODETYPE}

X=$NODETYPE
if [[ "$X" != "N0" &&  "$X" != "N1" &&  "$X" != "N2" && "$X" != "NTEST" ]]; then
  exit -1
fi

if [ "$NODETYPE" == "NTEST" ]; then TEST_ZOOKEEPER_ID=0; fi

NODESTATE="$2" # default is inst, but we may have a spare type

CFG=../config
HCFG_TEMPL=${CFG}/hadoop-cluster-config-template

TEMPL_CDAP_CONF=../config/cdap-config-template
CDAP_CONF_FOLDER=../config/cdap-config

HADOOP_CONF_FOLDER=../config/hadoop-cluster-config
HADOOP_SCRIPT_FOLDER=../pkgs/services

IS_INITIAL=1 # Fresh cluster
MAXHOSTS=3 

if [[ -n "$NODESTATE" && "inst" != "$NODESTATE" ]]; then
   IS_ISINITIAL=
fi

process_generic_node

# [DE248724] configure tmpfiles.d
cp ../pkgs/ubuntu-files/cdap-hadoop-run.conf /usr/lib/tmpfiles.d/
chmod 644 /usr/lib/tmpfiles.d/cdap-hadoop-run.conf

cp ../pkgs/ubuntu-files/create_pid_dirs.sh "${__SERVICE_CONFIG_FOLDER__}"/
chmod 755 "${__SERVICE_CONFIG_FOLDER__}"/create_pid_dirs.sh

cp $HADOOP_SCRIPT_FOLDER/boot-time-cdap-vm-${NODETYPE}.sh "${__SERVICE_CONFIG_FOLDER__}"/boot-time-cdap-vm.sh
cp $HADOOP_SCRIPT_FOLDER/cdap-vm-services /etc/init.d
chmod +x /etc/init.d/cdap-vm-services

# Ubuntu service enable:
#
update-rc.d cdap-vm-services defaults

\. ./utils/cdap-nodetype-${NODETYPE}.sh

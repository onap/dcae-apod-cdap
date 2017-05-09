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

cd $(dirname $0)

CFG=../config
HOST_XREF=${CFG}/hostname-xref.txt
CLUSTER_H_TEMPLATE=${CFG}/hadoop-cluster-hosts-file.sh.tmpl 
CLUSTER_HOSTS=${CFG}/hadoop-cluster-hosts-file.sh 

HADOOP_CONF_FOLDER=../config
HADOOP_SCRIPT_FOLDER=../pkgs/services
HADOOP_SERVICE_SETUP_FOLDER=../pkgs/services-setup

TEMPL_CDAP_CONF=../config/cdap-config-template
CDAP_CONF_FOLDER=../config/cdap-config

# Hack to set system time to UTC first time
if [ -e /etc/localtime ]; then
   rm /etc/localtime # remove it even if it is a symbolic link 
fi
cp /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# Hack for 127.0.1.1 entry in /etc/hosts on Ubuntu images
#
sed  '/^#/! {/127\.0\.1\.1/ s/^/# /}' -i /etc/hosts

if [ "--no-hosts" = "$1" ]; then 
   echo "Using test hosts"
   HOST_XREF=${HOST_XREF}.test
else
   bash ./utils/generate-hosts.sh > ${HOST_XREF}
fi

process_template() {
   template="$1"
   output_file="$2"
   xref_file="$3"
   python ./utils/replace-kv.py ${template} ${output_file} ${xref_file}
}

process_hadoop_service_scripts() {
   for x in "$@"; do
       srcscript=${HADOOP_CONF_FOLDER}/services-templates/"${x}"
       destscript=${HADOOP_SCRIPT_FOLDER}/"${x}"
       xref_file=${MAIN_CLUSTER_CONFIG_XREF}
       process_template ${srcscript} ${destscript} ${xref_file}
   done
}

process_hadoop_service_setup_scripts() {
   for x in "$@"; do
       srcscript=${HADOOP_CONF_FOLDER}/services-setup-templates/"${x}"
       destscript=${HADOOP_SERVICE_SETUP_FOLDER}/"${x}"
       xref_file=${MAIN_CLUSTER_CONFIG_XREF}
       process_template ${srcscript} ${destscript} ${xref_file}
   done
}


process_template ${CLUSTER_H_TEMPLATE} ${CLUSTER_HOSTS} ${HOST_XREF}

# CLUSTER_HOSTS now has information on what NODE0, NODE1, etc., mean
# CLUSTER_HADOOP_CONF has information on folders, etc.
CLUSTER_HADOOP_CONF=${CFG}/hadoop-cluster-conf-file.sh

MAIN_CLUSTER_CONFIG_XREF=${CFG}/main-conf.sh
# group them together
cat ${CLUSTER_HADOOP_CONF} ${CLUSTER_HOSTS} ${HOST_XREF} > ${MAIN_CLUSTER_CONFIG_XREF}

# Create target configs from hadoop-config-templates
HCFG_TEMPL=${CFG}/hadoop-cluster-config-template

HCFG=${CFG}/hadoop-cluster-config

process_config_files() {
   sfolder="$1"
   mkdir -p ${HCFG}/${sfolder}
   for x in ${HCFG_TEMPL}/${sfolder}/*; do
       if [ -d $x ]; then continue; fi  # skip folder
       item=${x#$HCFG_TEMPL/}
       template=${HCFG_TEMPL}/${item} 
       output_file=${HCFG}/${item}
       process_template ${template} ${output_file} ${MAIN_CLUSTER_CONFIG_XREF}
   done
}

process_config_folder() {
   sfolder="$1"
   dfolder="$2"
   mkdir -p ${dfolder}
   for x in ${sfolder}/*; do
       if [ -d $x ]; then continue; fi  # skip folder
       item=${x#$sfolder/}
       template=${x}
       output_file=${dfolder}/${item}
       process_template ${template} ${output_file} ${MAIN_CLUSTER_CONFIG_XREF}
   done
}

process_config_files core_hadoop 
process_config_files zookeeper
process_config_files hbase

process_config_folder ${TEMPL_CDAP_CONF} ${CDAP_CONF_FOLDER}
process_config_folder ${TEMPL_CDAP_CONF}/common ${CDAP_CONF_FOLDER}/common


# TODO: We can simply process all files in the template folder for service_scripts?
process_hadoop_service_scripts \
   service-start.sh zookeeper.sh resource-manager.sh zookeeper-zkfc.sh \
   node-manager.sh namenode.sh datanode.sh secondary-namenode.sh  \
   job-history-server.sh hbase-master.sh hbase-regionserver.sh \
   utility-scripts.sh cdap.sh cdap-vm-services \
   boot-time-cdap-vm-N0.sh boot-time-cdap-vm-N1.sh boot-time-cdap-vm-N2.sh


# TODO: We can simply process all files in the template folder for service_setup_scripts?
process_hadoop_service_setup_scripts \
   service-setup.sh namenode-setup.sh zookeeper-start.sh zookeeper-zkfc-start.sh \
   resource-manager-start.sh node-manager-start.sh datanode-start.sh \
   job-history-setup-01-as-root.sh job-history-setup-02-as-hdfs.sh \
   datanode-start.sh hbase-master-start.sh hbase-regionserver-start.sh \
   cdap-setup.sh cdap-start.sh job-history-server-start.sh

chmod -R o+r ${HADOOP_SCRIPT_FOLDER}/..


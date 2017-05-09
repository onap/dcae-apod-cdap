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

#!/bin/bash

copy_hadoop_conf_files() {
   srcfolder=${HADOOP_CONF_FOLDER}/"$1"
   destfolder="$2"
   cp -a $srcfolder/* $destfolder/
}

copy_cdap_conf_files() {
   srcfolder=${CDAP_CONF_FOLDER}
   destfolder="${__CDAP_CONF_DIR__}"
   cp -a $srcfolder/cdap-* $srcfolder/log* $destfolder/
   # Hack for a common.sh file -- TODO: Make it more general
   cp -a $srcfolder/common/common.sh ${__CDAP_INST_FOLDER__}/ui/bin/common.sh
}

   
setup_hadoop_service_scripts() {
   for x in "$@"; do
       srcscript=${HADOOP_SCRIPT_FOLDER}/"${x}"
       destscript="${__SERVICE_CONFIG_FOLDER__}/${x}"
       cp -a $srcscript $destscript
   done
}
  
run_service_setup_script() {
   script="$1"
   user="$2"
   runner=${HADOOP_SERVICE_SETUP_FOLDER}/service-setup.sh
   srcscript=${HADOOP_SERVICE_SETUP_FOLDER}/"${script}"
   bash ${runner} ${script} ${user} # should not give full path
}
 
create_folder() {
    # Create a folder with a group and mode
    name=$1  # if there are spaces, there will be multiple folders
    user="$2"
    group="$3"
    mode="$4"

   mkdir -p $name  # if there are spaces, there will be multiple folders
   chown -R "$user":"$group" $name
   chmod -R "$mode" $name
}

inst_namenode() {
   if [ -n "$IS_INITIAL" ]; then
      rm -rf ${__DFS_NAME_DIR__}  # TODO: Move away from force delete?
      create_folder ${__DFS_NAME_DIR__} ${__HDFS_USER__} ${__HADOOP_GROUP__} 755
      run_service_setup_script namenode-setup.sh ${__HDFS_USER__} 
      setup_hadoop_service_scripts namenode.sh
   else
      exit -1; # We do not know what to do
   fi
}

inst_secondary_namenode() {
   if [ -n "$IS_INITIAL" ]; then
      create_folder ${__FS_CHECKPOINT_DIR__} ${__HDFS_USER__} ${__HADOOP_GROUP__} 755
      setup_hadoop_service_scripts secondary-namenode.sh
   else
      exit -1; # We do not know what to do
   fi
}

inst_yarn_basic() {
    create_folder ${__YARN_LOCAL_DIR__} ${__YARN_USER__} ${__HADOOP_GROUP__} 755
    create_folder ${__YARN_LOCAL_LOG_DIR__} ${__YARN_USER__} ${__HADOOP_GROUP__} 755
}   

inst_datanode_basic() {
    create_folder ${__HDFS_LOG_DIR__} ${__HDFS_USER__} ${__HADOOP_GROUP__} 755
    rm -rf ${__DFS_DATA_DIR__}  # TODO: Move away from force delete?
    create_folder ${__DFS_DATA_DIR__} ${__HDFS_USER__} ${__HADOOP_GROUP__} 750
    setup_hadoop_service_scripts datanode.sh
}   

inst_datanode() {
    run_service_setup_script datanode-start.sh ${__HDFS_USER__}
}

inst_hbase_basic() {
    create_folder ${__HBASE_LOG_DIR__} ${__HBASE_USER__} ${__HADOOP_GROUP__} 750
    create_folder ${__HBASE_PID_DIR__} ${__HBASE_USER__} ${__HADOOP_GROUP__} 750
    rm -rf ${__HBASE_CONF_DIR__}
    create_folder ${__HBASE_CONF_DIR__} ${__HBASE_USER__} ${__HADOOP_GROUP__} 755
    copy_hadoop_conf_files hbase ${__HBASE_CONF_DIR__}
}

inst_hbase_master() {
    run_service_setup_script hbase-master-start.sh ${__HBASE_USER__} 
    setup_hadoop_service_scripts hbase-master.sh 
}

inst_hbase_regionserver() {
    run_service_setup_script hbase-regionserver-start.sh ${__HBASE_USER__} 
    setup_hadoop_service_scripts hbase-regionserver.sh 
}

inst_core_files() {
   # For all  nodes
   # YARN logs
   create_folder ${__YARN_LOG_DIR__} ${__YARN_USER__} ${__HADOOP_GROUP__} 755
   # HDFS PID folder
   create_folder ${__HDFS_PID_DIR__} ${__HDFS_USER__} ${__HADOOP_GROUP__} 755
   # YARN Node Manager Recovery Directory
   create_folder ${__YARN_NODEMANAGER_RECOVERY_DIR__} ${__YARN_USER__} ${__HADOOP_GROUP__} 755
   # YARN PID folder
   create_folder ${__YARN_PID_DIR__} ${__YARN_USER__} ${__HADOOP_GROUP__} 755
   # JobHistory server logs
   create_folder ${__MAPRED_LOG_DIR__} ${__MAPRED_USER__} ${__HADOOP_GROUP__} 755
   # JobHistory PID folder
   create_folder ${__MAPRED_PID_DIR__} ${__MAPRED_USER__} ${__HADOOP_GROUP__} 755
   # hadoop conf dir
   rm -rf ${__HADOOP_CONF_DIR__}
   create_folder ${__HADOOP_CONF_DIR__} ${__HDFS_USER__} ${__HADOOP_GROUP__} 755
   # dfs.exclude -- before things are created
   touch ${__HADOOP_CONF_DIR__}/dfs.exclude 
   copy_hadoop_conf_files core_hadoop ${__HADOOP_CONF_DIR__}
}

inst_yarn_nodemanager() {
   run_service_setup_script node-manager-start.sh ${__YARN_USER__}
   setup_hadoop_service_scripts node-manager.sh
}

inst_yarn_resourcemanager() {
   run_service_setup_script resource-manager-start.sh ${__YARN_USER__}
   setup_hadoop_service_scripts resource-manager.sh 
}

inst_job_history_server() {
   run_service_setup_script job-history-setup-01-as-root.sh # no need for username then
   run_service_setup_script job-history-setup-02-as-hdfs.sh ${__HDFS_USER__}
   setup_hadoop_service_scripts job-history-server.sh  
   # [173931] Start MapReduce History Server during Hadoop install
   run_service_setup_script job-history-server-start.sh ${__MAPRED_USER__}
}

inst_cdap() {
   # note: cluster-prep is done along with namenode
   run_service_setup_script cdap-setup.sh  # as root
   setup_hadoop_service_scripts cdap.sh
   copy_cdap_conf_files 
   run_service_setup_script cdap-start.sh  # as root
}

inst_zookeeper() {
   # Zookeeper data folder
   create_folder ${__ZOOKEEPER_DATA_DIR__} ${__ZOOKEEPER_USER__} ${__HADOOP_GROUP__} 755
   # Zookeeper logs
   create_folder ${__ZOOKEEPER_LOG_DIR__} ${__ZOOKEEPER_USER__} ${__HADOOP_GROUP__} 755
   create_folder ${__ZKFC_LOG_DIR__} ${__HDFS_USER__} ${__HADOOP_GROUP__} 755
   # Zookeeper PID folder
   create_folder ${__ZOOKEEPER_PID_DIR__} ${__ZOOKEEPER_USER__} ${__HADOOP_GROUP__} 755
   # Put the Zookeeper ID into its folder
   get_zookeeper_id > ${__ZOOKEEPER_DATA_DIR__}/myid
   # Clean up Zookeeper conf folder
   rm -rf ${__ZOOKEEPER_CONF_DIR__}
   create_folder ${__ZOOKEEPER_CONF_DIR__} ${__ZOOKEEPER_USER__} ${__HADOOP_GROUP__} 755
   chmod 755 ${__ZOOKEEPER_CONF_DIR__}/..  # Parent folder of zookeeper
   # Copy zookeeper files
   copy_hadoop_conf_files zookeeper ${__ZOOKEEPER_CONF_DIR__}
   run_service_setup_script zookeeper-start.sh ${__ZOOKEEPER_USER__} 
   run_service_setup_script zookeeper-zkfc-start.sh ${__HDFS_USER__} 
}

get_cdap_host_id() {
   # we will set this based on the hostname
   base=$(hostname -s)
   base=$(echo $base | sed 's/^.*[^0-9]\([0-9][0-9]*\)/\1/g')
   base=${base: -1}  # get last digit. TODO: Need to make it scale?
   echo $base
}

get_zookeeper_id() {
   echo $(get_cdap_host_id) 
}

get_zookeeper_id_single_digit() {
   base=$(get_cdap_host_id)
   echo ${base: -1}
}

process_generic_node() {

  create_folder ${__SERVICE_CONFIG_FOLDER__} root root 755

  inst_core_files  # config files, creating, copying etc.
  setup_hadoop_service_scripts utility-scripts.sh
  setup_hadoop_service_scripts service-start.sh
  setup_hadoop_service_scripts zookeeper.sh 
  setup_hadoop_service_scripts zookeeper-zkfc.sh 

  inst_zookeeper
  inst_datanode_basic
  inst_hbase_basic
  inst_yarn_basic
} 

wait_for_remote_service() {
  remote_host="$1"
  remote_port="$2"
  sleep_time=${3:-30} # default of 30 seconds between retries

  # keep checking remote_host's remote_port every sleep_time seconds till we get a connection
  while ( ! nc $remote_host $remote_port < /dev/null ); do sleep $sleep_time ; done 
}

wait_for_namenode() {
  # keep checking namenode's port 8020 till it is up -- do it every 30 seconds
  wait_for_remote_service ${__HDP_NAMENODE__} 8020 30 
}

wait_for_hbase_master_start() {
  # keep checking hbase master's port 16000 till it is up -- do it every 30 seconds
  wait_for_remote_service ${__HDP_HBASE_MASTER__} 16000 30 
}

wait_for_hbase_shell_OK() {
  # run hbase shell and see if we connect to hbase... Better than waiting for ports
  while ( echo list | hbase shell 2>&1 | grep ^ERROR > /dev/null ); do
    sleep 30
  done
}

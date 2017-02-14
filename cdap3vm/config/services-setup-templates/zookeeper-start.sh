#!/bin/bash

# ZooKeeper

ACTION="start"

export ZOOCFGDIR=__ZOOKEEPER_CONF_DIR__
export ZOOCFG=zoo.cfg
source ${ZOOCFGDIR}/zookeeper-env.sh
__HDP_CURRENT_FOLDER__/zookeeper-server/bin/zkServer.sh "$ACTION" 



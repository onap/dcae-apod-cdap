#!/bin/bash

chown -R __SUPER_USER__:__HADOOP_USER__   __HDP_CURRENT_FOLDER__/hadoop-yarn*/bin/container-executor
chmod -R 6050 __HDP_CURRENT_FOLDER__/hadoop-yarn*/bin/container-executor

#!/bin/bash

sleep 100 # Wait for all things to sync up?
__HDP_CURRENT_FOLDER__/hbase-regionserver/bin/hbase-daemon.sh start regionserver


#!/bin/bash

export JAVA_HOME=__JAVA_HOME__

/etc/init.d/cdap-auth-server start
/etc/init.d/cdap-kafka-server start

# [186049] start router before master
/etc/init.d/cdap-router start
/etc/init.d/cdap-master start

PATH=$PATH:__NODEJS_BIN__
/etc/init.d/cdap-ui start

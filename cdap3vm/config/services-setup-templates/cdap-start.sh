#!/bin/bash

export JAVA_HOME=__JAVA_HOME__

/etc/init.d/cdap-auth-server start
/etc/init.d/cdap-kafka-server start
/etc/init.d/cdap-master start
/etc/init.d/cdap-router start

PATH=$PATH:__NODEJS_BIN__
/etc/init.d/cdap-ui start

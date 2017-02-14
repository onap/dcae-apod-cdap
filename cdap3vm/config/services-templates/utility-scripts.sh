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

wait_for_remote_service() {
  remote_host="$1"
  remote_port="$2"
  sleep_time=${3:-30} # default of 30 seconds between retries

  # keep checking remote_host's remote_port every sleep_time seconds till we get a connection
  while ( ! nc $remote_host $remote_port < /dev/null ); do sleep $sleep_time ; done
}

wait_for_namenode() {
  # keep checking namenode's port 8020 till it is up -- do it every 30 seconds
  wait_for_remote_service __HDP_NAMENODE__ 8020 30
}

wait_for_hbase_shell_OK() {
  # run hbase shell and see if we connect to hbase... Better than waiting for ports
  while ( echo list | hbase shell 2>&1 | grep ^ERROR > /dev/null ); do
    sleep 30
  done
}


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

# Default will be a production installation 
# Any test installation requires passing arguments to different steps

umask 0022
CDAPLOG=$(dirname $0)/cdap-hadoop-install.log

(
echo -n "### Start at: " 
date

cd $(dirname $0)/install-steps
pwd

echo
echo '## 01-generate-host-ids-configs.sh'
bash 01-generate-host-ids-configs.sh 

echo
echo '## 02-user-creation.sh'
bash 02-user-creation.sh

#bash 03-hadoop-rpms.sh

echo
echo '## install-hortonworks-hadoop.sh'
bash install-hortonworks-hadoop.sh

echo
echo '## install-cdap-pkgs.sh'
bash install-cdap-pkgs.sh

echo
echo '## 04-folder-creation.sh' 
bash 04-folder-creation.sh 

echo
echo -n "### End at: " 
date

) 2>&1 | tee -a $CDAPLOG


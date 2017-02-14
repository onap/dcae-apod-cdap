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

MAXHOSTID=2

fullhostname=$(hostname -f)
basehostname=${fullhostname%%.*}
restname=${fullhostname#*.}

basenum=$(echo $base | sed 's/^.*[^0-9]\([0-9][0-9]*\)/\1/g')
basenum=${basenum##0*}  # remove leading zeros

if [[ "${basenum}" -ge 0 && "${basenum}" -le ${MAXHOSTS} ]]; then
   for x in $(seq 0 $MAXHOSTID); do
      echo "__DCAE_CDAP_NODE${x}__=${basehostname::-1}${x}"
      # echo "__DCAE_CDAP_NODE${x}__=${basehostname::-1}${x}.${restname}"
      # echo "_CLUSTER_SERVER_PREFIX__0${x}=${basehostname::-1}${x}.${restname}"
   done
fi



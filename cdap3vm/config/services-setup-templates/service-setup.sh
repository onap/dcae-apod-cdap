#!/bin/bash

MAINLOC=$(dirname $0)
setup_script="${1}"

if [ -z "$2" ]; then
     bash ${MAINLOC}/${setup_script}
else 
   su "$2" -c "bash ${MAINLOC}/${setup_script}"
fi

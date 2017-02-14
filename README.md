Building the DCAE CDAP Cluster Package
========================================

This is the repository for the CDAP cluster that will be used for running analytics.  Currently this repository contains the scripts and packages to create a DCAE CDAP small hadoop package, which is a 3 node hadoop environment that CDAP will be installed on.

### Build Instructions

There is no source code to build.  This repository contains the scripts and packages used to install the CDAP 3 VM environment.

### Debian Packaging

The contents of this repository will be bundled into a Debian package and sent to the OpenECOMP Nexus server where
it will be picked up and installed by the DCAE Controller.  Following is the process to
create the Debian package and upload it to the OpenECOMP Nexus distribution server.


#### Extract the contents to package
```
git clone git@<repo-address>:dcae-apod/dcae-org.openecomp.cdapcluster.git
```

#### Set up the packaging environment
1. Extract the build tools and config file 
The build tools and configuration files for all of APOD are in the dcae-apod-buildtools repository which is part of the dcae-apod Project.
```
$ git clone ssh://git@<repo-address>:dcae-apod/dcae-apod-buildtools.git
```
From this repo you will need:
 - The package script from the scripts directory
 - The package-cdap3vm.json file from the configs directory

2. Set up the packaging environment
The packaging script requires directories named stage and output.  The stage directory will contain all the directories and files that will packaged.  The output directory is where the Debian file will be put.

The package-cdap3vm.json configuration file contains the parameters that the package script needs in order to create the Debian package.  

NOTE: The user should only set the variables between the "User sets these" block.  The Debian file MUST have a specific name in order for the DCAE controller to find it an install it.   
```
###########  User sets these            ###############
WORK_DIR=/path/to/your/work/dir/               # This is the path of where you will do your packaging
BUILD_TOOLS_DIR=/path/to/dcae-apod-buildtools  # This is the path to dcae-apod-buildtools directory 
CDAP3VM_SOURCE_DIR=/path/to/source/dir         # This is the where you have checked out dcae-org.openecomp.cdapcluster
OPENECOMP_NEXUS_RAW=https://xx.xx.xx:8443/repository/raw  # This is the URL of the OpenECOMP raw repository in the Nexus distribution server
OPENECOMP_NEXUS_USER=user-name
OPENECOMP_NEXUS_PASSWORD=password
###########  End of user set variables  ###############

STAGE_DIR=${WORK_DIR}/package
OUTPUT_DIR=${WORK_DIR}/package/output

DATE_STAMP="$(date +"%Y%m%d%H%M%S")"
PACKAGE_BUILD_NUMBER="LATEST"
PACKAGE_NAME_APPLICATION=$(cat ${BUILD_TOOLS_DIR}/dcae-apod-buildtools/configs/package-cdap3vm.json | python -c 'import json,sys;print json.load(sys.stdin)["applicationName"]')
PACKAGE_NAME_VERSION=$(cat ${BUILD_TOOLS_DIR}/dcae-apod-buildtools/configs/package-cdap3vm.json | python -c 'import json,sys;print json.load(sys.stdin)["version"]')
PACKAGE_GROUP_ID=$(cat ${BUILD_TOOLS_DIR}/dcae-apod-buildtools/configs/package-cdap3vm.json | python -c 'import json,sys;print json.load(sys.stdin)["groupId"]')

OUTPUT_FILE=${PACKAGE_NAME_APPLICATION}"_"${PACKAGE_NAME_VERSION}"-"${PACKAGE_BUILD_NUMBER}".deb"
OUTPUT_FILE_DATE_STAMPED=${PACKAGE_NAME_APPLICATION}"_"${PACKAGE_NAME_VERSION}"-"${DATE_STAMP}".deb"

rm -rf ${STAGE_DIR}
rm -rf ${OUTPUT_DIR}
mkdir -p ${STAGE_DIR}/stage/opt/app/dcae-cdap-small-hadoop
mkdir -p ${OUTPUT_DIR}

echo "Copying jar file to stage"
cp -R ${CDAP3VM_SOURCE_DIR}/CDAP3VM ${STAGE_DIR}/stage/opt/app/dcae-cdap-small-hadoop

echo "Copying json config file to stage"
cp ${BUILD_TOOLS_DIR}/dcae-apod-buildtools/configs/package-cdap3vm.json ${STAGE_DIR}/package.json
```
#### Run the script to create the Debian package
The package script will package what is in the stage directory as well as create a debian control file, change log, copyright file, md5checksums file and a postint file with any post install steps that need to be run as part of the installation. 

The package script will put the Debian file that is created in ${OUTPUT_DIR}
```
echo "Creating debian package"
${BUILD_DIR}/dcae-apod-buildtools/scripts/package -b debian -d ${STAGE_DIR} -o ${OUTPUT_DIR} -y package.json -B ${PACKAGE_BUILD_NUMBER} -v
```
#### Push the package to the OpenECOMP Nexus distribution server 
<P>The Debian package that is created needs to be pushed up to the OpenECOMP Nexus distribution server where the DCAE Controller will pick it up an install it.
<P>The controller needs the debian packaged named dcae-cdap-small-hadoop_17.01.0-LATEST.deb so it can find and deploy it.  In order to have a copy of each file built a copy of dcae-cdap-small-hadoop_17.01.0-LATEST.deb will be made and it will have a date stamp and build number on it.  For example:  dcae-cdap-small-hadoop_17.01.0-YYYYMMDDHHMMSS-XXX.deb Both files will then be uploaded to the repository.

```
cp ${OUTPUT_DIR}/${OUTPUT_FILE} ${OUTPUT_DIR}/${OUTPUT_FILE_DATE_STAMPED}

SEND_TO=${OPENECOMP_NEXUS_RAW}"/org.openecomp.dcae/deb-snapshots/"${PACKAGE_GROUP_ID}"/"${OUTPUT_FILE}
curl -vk --user ${OPENECOMP_NEXUS_USER}:${OPENECOMP_NEXUS_PASSWORD} --upload-file ${OUTPUT_DIR}/${OUTPUT_FILE} ${SEND_TO}

SEND_TO=${OPENECOMP_NEXUS_RAW}"/org.openecomp.dcae/deb-snapshots/"${PACKAGE_GROUP_ID}"/"${OUTPUT_FILE_DATE_STAMPED}
curl -vk --user ${OPENECOMP_NEXUS_USER}:${OPENECOMP_NEXUS_PASSWORD} --upload-file ${OUTPUT_DIR}/${OUTPUT_FILE_DATE_STAMPED} ${SEND_TO}
```

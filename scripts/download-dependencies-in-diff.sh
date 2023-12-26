#!/bin/bash
THIS_SCRIPT=$(basename -- "$0")
WORKDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# NEXUS_HOST_SOURCE=nexus.example.com
# REPOSITORY_SOURCE=gaide

while read line
do
    rec_groupId=$(echo $line | awk -F' ' '{print $1}')
    rec_artifactId=$(echo $line | awk -F' ' '{print $2}')
    rec_version=$(echo $line | awk -F' ' '{print $3}')
    rec_groupIdFolder=${rec_groupId//\./\/}
    rec_downloadUrl="http://${NEXUS_HOST_SOURCE}/repository/${REPOSITORY_TARGET}/${rec_groupIdFolder}/${rec_artifactId}/${rec_version}/${rec_artifactId}-${rec_version}.jar"

    echo "groupId: $rec_groupId"
    echo "artifactId: $rec_artifactId"
    echo "version: $rec_version"
    echo "downloadUrl: $rec_downloadUrl"

    mkdir -p ${WORKDIR}/../dependencies

    # dowlnoad
    curl -o ${WORKDIR}/../dependencies/${rec_artifactId}-${rec_version}.jar -u admin:admin123 "${rec_downloadUrl}"
done < ${WORKDIR}/../diff.csv
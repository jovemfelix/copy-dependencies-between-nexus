#!/bin/bash
THIS_SCRIPT=$(basename -- "$0")
WORKDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
# NEXUS_HOST_TARGET=nexus.example.com
# REPOSITORY_TARGET=gaide

while read line
do
    rec_groupId=$(echo $line | awk -F' ' '{print $1}')
    rec_artifactId=$(echo $line | awk -F' ' '{print $2}')
    rec_version=$(echo $line | awk -F' ' '{print $3}')

    echo "*********************************"
    echo "groupId: $rec_groupId"
    echo "artifactId: $rec_artifactId"
    echo "version: $rec_version"

    # upload
    curl -v -u ${NEXUS_USER_PASS} \
         -F "maven2.generate-pom=true" \
         -F "maven2.packaging=jar" \
         -F "maven2.asset1.extension=jar" \
         -F "maven2.groupId=$rec_groupId" \
         -F "maven2.artifactId=$rec_artifactId" \
         -F "version=$rec_version" \
         -F "maven2.asset1=@${WORKDIR}/../${DEPENDENCIES_FOLDER}/${rec_artifactId}-${rec_version}.jar;type=application/java-archive" \
         "http://${NEXUS_HOST_TARGET}/service/rest/v1/components?repository=${REPOSITORY_TARGET}"
         
done < ${WORKDIR}/../diff.csv

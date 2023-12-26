THIS_SCRIPT=$(basename -- "$0")
WORKDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

NEXUS_HOST=$1
REPOSITORY=$2
NEXUS_USER_PASS=$3
# REPOSITORY_FOLDER=repo

echo "
NEXUS_HOST = ${NEXUS_HOST}
REPOSITORY = ${REPOSITORY}
NEXUS_USER_PASS = ${NEXUS_USER_PASS}
REPOSITORY_FOLDER = ${REPOSITORY_FOLDER}
"

CONTINUATION_TOKEN=null
OUTPUT_REPOSITORY_FOLDER="${WORKDIR}/../${REPOSITORY_FOLDER}"

mkdir -p ${OUTPUT_REPOSITORY_FOLDER}/${NEXUS_HOST}

function continuationTokenFromJsonFile() {
     jq -r '.continuationToken' ${OUTPUT_REPOSITORY_FOLDER}/${NEXUS_HOST}/${REPOSITORY}-${1}.json
}

function searchAssets(){
     echo "${NEXUS_HOST} [${REPOSITORY}][${1}] ${CONTINUATION_TOKEN}"
     if [[ ${1} == '0' ]]; 
     then
          curl -s -o ${OUTPUT_REPOSITORY_FOLDER}/${NEXUS_HOST}/${REPOSITORY}-${1}.json \
               -u ${NEXUS_USER_PASS} \
               "http://${NEXUS_HOST}/service/rest/v1/search/assets?repository=${REPOSITORY}&maven.extension=jar" \
               -H "accept: application/json"
     else 
          curl -s -o ${OUTPUT_REPOSITORY_FOLDER}/${NEXUS_HOST}/${REPOSITORY}-${1}.json \
               -u ${NEXUS_USER_PASS} \
               "http://${NEXUS_HOST}/service/rest/v1/search/assets?repository=${REPOSITORY}&maven.extension=jar&continuationToken=${CONTINUATION_TOKEN}" \
               -H "accept: application/json"
     fi
}

page=0
searchAssets $page

CONTINUATION_TOKEN=$(continuationTokenFromJsonFile $page)

while [[ ${CONTINUATION_TOKEN} != 'null' ]]
do 
     (( page++ ))
     searchAssets $page
     sleep 3s
     CONTINUATION_TOKEN=$(continuationTokenFromJsonFile $page)
done 

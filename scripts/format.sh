# jq -r '.items[].maven2' | [.groupId, .artifactId, .version] | @tsv assets.json

REPOSITORY=gaide
jq -r '.items[].maven2 | [.groupId, .artifactId, .version] | @tsv' ${REPOSITORY}.json | sort > ${REPOSITORY}.csv

# variables
# REPOSITORY_FOLDER=repo

for d in ${REPOSITORY_FOLDER}/* ; do
     if [ -d "$d" ]; then
        NEXUS_HOST=${d#*/*}
        echo "${NEXUS_HOST}"
        for j in ${d}/*.json ; do
          if [ -f "$j" ]; then          
               REPOSITORY=$(b=${j##*/}; echo ${b%.*})
               REPOSITORY_MAIN=$(echo "${REPOSITORY}"| cut -d'-' -f 1)
               echo "${REPOSITORY}"
               # echo "==> ${j}"
               jq -r '.items[] | [.maven2.groupId, .maven2.artifactId, .maven2.version] | @tsv' ${j} >> ${REPOSITORY_FOLDER}/${NEXUS_HOST}/${REPOSITORY_MAIN}.csv
          fi    
        done
        sort -o ${REPOSITORY_FOLDER}/${NEXUS_HOST}/${REPOSITORY_MAIN}.csv ${REPOSITORY_FOLDER}/${NEXUS_HOST}/${REPOSITORY_MAIN}.csv
    fi    
done

# browse repository
> http://${NEXUS_HOST}/#admin/repository/repositories 

# cleanup.sh
> Limpar o ambiente
```shell
# nome da pasta onde será baixado JSON's dos repositórios
export REPOSITORY_FOLDER=repo
sh scripts/cleanup.sh
```

# download-assets-info.sh
> baixar meta-info (JSON) do repositório
> repetir a chamada ao script para cada novo repositório
```shell
# nome host do nexus a ser exportado
NEXUS_HOST=nexus.example.com

# nome do repositório que ser usado
REPOSITORY=gaide

# usuário e senha para baixar no nexus
NEXUS_USER_PASS="admin:admin123"

# nome da pasta onde será baixado JSON's dos repositórios
export REPOSITORY_FOLDER=repo

# nome da pasta que irá conter as dependencias baixadas no repositório de origem
export DEPENDENCIES_FOLDER=dependencies

sh scripts/download-assets-info.sh $NEXUS_HOST $REPOSITORY $NEXUS_USER_PASS

NEXUS_HOST=nexus-old.example.com
sh scripts/download-assets-info.sh $NEXUS_HOST $REPOSITORY $NEXUS_USER_PASS
```

# convertToCSV.sh
> Converter META-INFO(JSONs) num arquivo CSV por repositório de cada host nexus
```shell
sh scripts/convertToCSV.sh
```

# difference-between-hosts.sh
> Informar quais repositórios serão considerados na comparação
> Vê a diferenca entre os respectivos arquivos CSV's
```shell
export NEXUS_HOST_SOURCE=nexus-old.example.com
export REPOSITORY_SOURCE=gaide

export NEXUS_HOST_TARGET=nexus.example.com
export REPOSITORY_TARGET=gaide

sh scripts/difference-between-hosts.sh

# contar as diferencas
cat diff.csv | wc -l
```


# download-dependencies-in-diff.sh
> Usa o arquivo `diff.csv` do processo anterior para baixar as dependências.
```shell

sh scripts/download-dependencies-in-diff.sh

# veja se a quantidade confere
ls -1 dependencies | wc -l
cat diff.csv | wc -l
```


# upload-dependencies.sh
> Enviar as dependências baixadas para o repositório alvo
```shell
sh scripts/upload-dependencies.sh
```



# Referências
* https://stackoverflow.com/questions/43843273/rest-api-to-get-list-of-artifacts-from-nexus-oss-3-x-repository
* https://help.sonatype.com/repomanager3/integrations/rest-and-integration-api/search-api
* https://stackoverflow.com/questions/39139107/how-to-format-a-json-string-as-a-table-using-jq
* https://stackoverflow.com/questions/15384818/how-to-get-the-difference-only-additions-between-two-files-in-linux
* https://stackoverflow.com/questions/4544709/compare-two-files-line-by-line-and-generate-the-difference-in-another-file
* https://help.sonatype.com/repomanager3/integrations/rest-and-integration-api/components-api#ComponentsAPI-UploadComponent
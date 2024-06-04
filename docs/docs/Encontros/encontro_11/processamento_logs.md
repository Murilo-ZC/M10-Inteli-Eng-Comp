---
sidebar_position: 6
title: Processamento dos Logs - Filebeat
---

import useBaseUrl from '@docusaurus/useBaseUrl';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Processamento dos Logs - Filebeat

Legal pessoal, até aqui, temos nossos logs configurados e nosso sistema gerando eles muito bem obrigado! Estão sendo gerados no formato de JSON e podem ser acessados para processamento posterior. Vamos nos atentar a esse ponto: processamento dos logs. 

O processamento dos logs é uma tarefa importante, pois é a partir dele que conseguimos extrair informações relevantes para a tomada de decisão. Existem diversas ferramentas que podem ser utilizadas para processamento de logs, como o Logstash, Fluentd, Splunk, entre outras. Neste encontro, vamos utilizar o Filebeat para processar os logs gerados pelo nosso sistema.

## Filebeat

O Filebeat é um coletor de logs leve e encaminhador de dados que pode ser instalado em servidores para coletar logs de arquivos locais. Ele ajuda a centralizar e analisar logs e arquivos de diferentes locais, permitindo que você monitore e visualize dados em tempo real. O Filebeat é parte do Elastic Stack, que é uma coleção de ferramentas para coleta, armazenamento, pesquisa e visualização de dados.

O Filebeat foi escrito em Go e é mantido pela Elastic. Ele é um agente que é instalado em servidores para coletar logs de arquivos locais e encaminhá-los para o Logstash ou Elasticsearch. Para que ele funcione, é necessário configurar os arquivos de configuração para que ele saiba quais logs coletar e para onde enviá-los. Em geral, esses arquivos de configuração são escritos em YAML e são bastante simples de configurar.

:::info[Filebeat]

Para saber mais sobre o Filebeat:

- [Documentação](https://www.elastic.co/pt/beats/filebeat)
- [Executando o Filebeat em um container](https://www.elastic.co/guide/en/beats/filebeat/current/running-on-docker.html)
- [Imagem no Dockerhub](https://hub.docker.com/r/elastic/filebeat)

<iframe width="560" height="315" src="https://www.youtube.com/embed/ykuw1piMGa4?si=XkRddHu6cU-0RR-u" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

:::


## Configurando nossa aplicação para enviar logs para o Filebeat

Pessoal vamos agora configurar nossa aplicação para que ela possa ser executada de um container e enviar os logs para o Filebeat. Para isso, vamos criar um Dockerfile para nossa aplicação.

:::warning[Atenção - sistema03]

Pessoal, só atenção pois estaremos rodando nosso programa agora em relação ao repositório `sistema03`.

:::

Dentro do diretório `backend`, vamos criar nosso Dockerfile para rodar nossa aplicação.

```Dockerfile title="backend/Dockerfile" showLineNumbers=true
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["fastapi", "run", "src/main.py", "--host", "0.0.0.0", "--port", "8000"]
```

Agora vamos adicionar na raiz do nosso projeto um arquivo chamado `docker-compose.yml` para configurar construir a imagem do nosso sistema.

```yaml title="docker-compose.yml" showLineNumbers=true
version: "3.8"

services:
  backend:
    build: ./backend/
    ports:
      - "8000:8000"
    container_name: backend
```

Para rodar nossa aplicação, vamos executar o seguinte comando:

```bash
docker-compose up --build --force-recreate
```

Importante observar, que ao pedir para nosso sistema ser executado desta maneira, estamos pedido para o Docker construir a imagem do nosso sistema e recriar elas. Vamos agora para o próximo passo, que é adicionar o Filebeat ao nosso sistema.


## Adicionando o Filebeat ao nosso sistema

Para adicionar o Filebeat ao nosso sistema, vamos criar um arquivo de configuração para ele. O arquivo de configuração do Filebeat é escrito em YAML e contém as configurações necessárias para coletar os logs e encaminhá-los para o Logstash ou Elasticsearch. Vamos criar um arquivo chamado `filebeat.yml` na pasta `filebeat` do nosso projeto e adicionar as seguintes configurações:


```yaml title="filebeat/filebeat.yml" showLineNumbers=true
# The name of the shipper that publishes the network data. It can be used to group
# all the transactions sent by a single shipper in the web interface.
# If this option is not defined, the hostname is used.
name: "filebeat"
logging.metrics.enabled: true
xpack.security.enabled: false
xpack.monitoring.enabled: false
setup.ilm.enabled: false
setup.template.enabled: false

monitoring:
  enabled: true
  elasticsearch:
    username: elastic
    password: senha

filebeat.inputs:
- type: log
  scan_frequency: 1s
  enabled: true
  paths:
    - /src/logs/*
  fields:
    - service: backend
  fields_under_root: true

output.elasticsearch:
  hosts: "http://0.0.0.0:9200"
  username: "elastic"
  password: "senha"
  index: "meus-logs"
setup.kibana:
  host: "http://kibana:5601"

http:
  enabled: true
  host: 0.0.0.0
```

Vamos compreender o que está acontecendo aqui:

- `name`: Nome do shipper que publica os dados de rede. Pode ser usado para agrupar todas as transações enviadas por um único shipper na interface web. Se esta opção não for definida, o nome do host é usado.
- `logging.metrics.enabled`: Habilita ou desabilita a coleta de métricas de log.
- `xpack.security.enabled`: Habilita ou desabilita a segurança do X-Pack.
- `xpack.monitoring.enabled`: Habilita ou desabilita o monitoramento do X-Pack.
- `setup.ilm.enabled`: Habilita ou desabilita o gerenciamento do ciclo de vida do índice.
- `setup.template.enabled`: Habilita ou desabilita a configuração do template do índice.
- `filebeat.inputs`: Configurações para a entrada de logs.
  - `type`: Tipo de entrada de log.
  - `scan_frequency`: Frequência de verificação dos logs.
  - `enabled`: Habilita ou desabilita a entrada de logs.
  - `paths`: Caminho dos logs.
  - `fields`: Campos adicionais para os logs.
  - `fields_under_root`: Define se os campos adicionais devem ser adicionados ao nível superior do documento.
- `output.elasticsearch`: Configurações para a saída dos logs para o Elasticsearch.
    - `hosts`: Endereço do Elasticsearch.
    - `index`: Nome do índice.


E vamos configurar o arquivo `Dockerfile` do Filebeat para que ele possa ser executado em um container.

```Dockerfile title="filebeat/Dockerfile" showLineNumbers=true
FROM docker.elastic.co/beats/filebeat:8.13.4

COPY filebeat.yml /usr/share/filebeat/filebeat.yml

USER root

RUN chown -R root /usr/share/filebeat/filebeat.yml
RUN chmod -R go-w /usr/share/filebeat/filebeat.yml

```



:::info[Filebeat.reference.yml]

Pessoal o arquivo de referência do Filebeat pode ser encontrado [aqui](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-reference-yml.html).

:::

Agora vamos modificar nosso arquivo `docker-compose.yml` para adicionar o Filebeat ao nosso sistema.

```yaml title="docker-compose.yml" showLineNumbers=true
version: "3.8"

services:
  backend:
    build: ./backend/
    ports:
      - "8000:8000"
    container_name: backend
    volumes:
      - ./logs:/app/logs

  filebeat:
    build: ./filebeat/
    container_name: filebeat
    volumes:
      - ./logs:/src/logs
    depends_on:
      - backend
    network_mode: "host"
```

Agora vamos rodar nosso sistema com o Filebeat.

```bash
docker-compose up --build --force-recreate
```

E pronto! Nosso sistema está sendo executado!

> Murilo, sem querer ser chato, mas o que é esse `network_mode: "host"`?

O `network_mode: "host"` é uma configuração que permite que o container use a rede do host. Isso é útil quando você deseja que o container tenha acesso à rede do host, como no caso do Filebeat, que precisa se conectar ao Elasticsearch.

> Mas Murilo, ainda não falamos sobre esse Elasticsearch, o que é isso? E antes disso ainda, o que mudou no nosso sistema?

Calma, calma, vamos por partes. Primeiro, vamos falar sobre o que mudou no nosso sistema e depois vamos falar sobre o Elasticsearch.

Agora, nos temos nosso backend produzindo os logs quando ele é executado e o Filebeat coletando esses logs. Como ainda não configuramos o Elasticsearch, ainda não estamos conseguindo ver esses logs. Vamos configurar o Elasticsearch e o Kibana para visualizar esses logs.

## O Elasticsearch e o Kibana

O Elasticsearch é um mecanismo de busca e análise de código aberto que armazena, pesquisa e analisa grandes volumes de dados em tempo real. Ele é usado para indexar e pesquisar logs, métricas, eventos e outros tipos de dados. O Elasticsearch é parte do Elastic Stack, que é uma coleção de ferramentas para coleta, armazenamento, pesquisa e visualização de dados.

Já o Kibana é uma ferramenta de visualização de dados que permite criar gráficos, tabelas e mapas a partir dos dados armazenados no Elasticsearch. Ele é usado para visualizar e analisar logs, métricas, eventos e outros tipos de dados. O Kibana é parte do Elastic Stack e é usado em conjunto com o Elasticsearch para criar painéis de monitoramento e dashboards.

O Elasticsearch e o Kibana são ferramentas poderosas que podem ser usadas para armazenar, pesquisar e visualizar logs e métricas em tempo real. Eles são amplamente utilizados em ambientes de produção para monitorar e analisar sistemas e aplicações.

:::info[Para saber mais]

<iframe width="560" height="315" src="https://www.youtube.com/embed/RLtJpFaWcmI?si=z5Ofb-nB4EEt5xhJ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/vXLOTEzuZAg?si=7viq4oNs6tJUNc95" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

:::

## Configurando o Elasticsearch e o Kibana

Vamos adicionar o Elasticsearch e o Kibana ao nosso sistema. Para isso, vamos criar um arquivo de configuração para o Elasticsearch e o Kibana. O arquivo de configuração do Elasticsearch é escrito em YAML e contém as configurações necessárias para iniciar o Elasticsearch, o mesmo comportamento será realizado com o Kibana.

Vamos criar um arquivo chamado `elasticsearch.yml` na pasta `elasticsearch` do nosso projeto e adicionar as seguintes configurações:

```yaml title="elasticsearch/elasticsearch.yml" showLineNumbers=true
## Default Elasticsearch configuration from Elasticsearch base image.
## https://github.com/elastic/elasticsearch/blob/main/distribution/docker/src/docker/config/elasticsearch.yml
#
cluster.name: docker-cluster
network.host: 0.0.0.0

## X-Pack settings
## see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-settings.html
#
xpack.license.self_generated.type: basic
xpack.security.enabled: false
```

E um Dockerfile para o Elasticsearch:

```Dockerfile title="elasticsearch/Dockerfile" showLineNumbers=true
FROM docker.elastic.co/elasticsearch/elasticsearch:8.13.4

COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml:ro,Z

ENV node.name=elasticsearch

ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"

ENV discovery.type=single-node

ENV ELASTIC_USERNAME=elastic

ENV ELASTIC_PASSWORD=senha

ENV xpack.security.enabled=false

ENV http.host=0.0.0.0

EXPOSE 9200 9300

```

Agora vamos fazer a mesma coisa para o Kibana:
    
```yaml title="kibana/kibana.yml" showLineNumbers=true
## Default Kibana configuration from Kibana base image.
## https://github.com/elastic/kibana/blob/main/src/dev/build/tasks/os_packages/docker_generator/templates/kibana_yml.template.ts
#
server.name: kibana
server.host: 0.0.0.0
server.port: 5601
elasticsearch.hosts: "http://elasticsearch:9200"

monitoring.ui.container.elasticsearch.enabled: true
monitoring.ui.container.logstash.enabled: true

## X-Pack security credentials
#
elasticsearch.username: kibana
elasticsearch.password: kibana

## Encryption keys (optional but highly recommended)
##
## Generate with either
##  $ docker container run --rm docker.elastic.co/kibana/kibana:8.6.2 bin/kibana-encryption-keys generate
##  $ openssl rand -hex 32
##
## https://www.elastic.co/guide/en/kibana/current/using-kibana-with-security.html
## https://www.elastic.co/guide/en/kibana/current/kibana-encryption-keys.html
#
#xpack.security.encryptionKey:
#xpack.encryptedSavedObjects.encryptionKey:
#xpack.reporting.encryptionKey:

```

E o seu respectivo Dockerfile:

```Dockerfile title="kibana/Dockerfile" showLineNumbers=true
FROM docker.elastic.co/kibana/kibana:8.13.4

COPY kibana.yml /usr/share/kibana/config/kibana.yml:ro,Z

EXPOSE 5601
```

Agora ajustamos nosso `docker-compose.yml` para lançar o Elasticsearch e o Kibana:

```yaml title="docker-compose.yml" showLineNumbers=true
version: "3.8"

services:
  backend:
    build: ./backend/
    ports:
      - "8000:8000"
    container_name: backend
    volumes:
      - ./logs:/app/logs

  filebeat:
    build: ./filebeat/
    container_name: filebeat
    volumes:
      - ./logs:/src/logs
    depends_on:
      - backend
      - elasticsearch
      - kibana
    network_mode: "host"

  elasticsearch:
    build: ./elasticsearch/
    container_name: elasticsearch
    ports:
      - "9200:9200"
      - "9300:9300"

  kibana:
    build: ./kibana/
    container_name: kibana
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch

volumes:
    elasticsearch_data:
        driver: local
```

Leva um tempo para os dois servços estarem prontos. Podemos ver se o serviço do Elasticsearch está pronto acessando o endereço `http://localhost:9200` e o Kibana acessando o endereço `http://localhost:5601`.

Agora pessoal temos nosso sistema rodando e os logs sendo coletados pelo Filebeat e enviados para o Elasticsearch. Podemos acessar o Kibana para visualizar esses logs e criar dashboards para monitorar nosso sistema.

Gente eu recomendo fortemente que vocês explorem o Kibana, ele é uma ferramenta muito poderosa e pode ser usada para criar dashboards personalizados para monitorar e analisar logs e métricas em tempo real.
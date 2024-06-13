---
sidebar_position: 2
title: Projeto de Autenticação e Autorização
---

import useBaseUrl from '@docusaurus/useBaseUrl';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Projeto de Autenticação e Autorização

O projeto de autenticação e autorização é um projeto que visa implementar um sistema de autenticação e autorização em um sistema de gerenciamento de usuários. O sistema deve permitir que usuários se cadastrem, façam login e logout, e que possam acessar recursos do sistema de acordo com as permissões que possuem.

## Proposta de Infraestrutura

Para nossos usuários, vamos utilizar a seguinte representação:
    
```json
{
    "id": "1",
    "name": "Nome do Usuário",
    "email": "meuemail@email.com",
    "password": "a345f2345c123341",
    "roles": ["admin", "user"]
    "criado_em": "2021-06-01T12:00:00Z",
    "atualizado_em": "2021-06-01T12:00:00Z"
}
```

Como banco de dados, vamos utilizar o Postgres. Para isso, vamos utilizar o Docker para subir um container com o banco de dados. Já vamos subir ele com um `docker-compose.yml` que já vai criar o banco de dados e a tabela de usuários.

```yaml
# Use postgres/example user/password credentials
version: '3.9'

services:

  db:
    image: postgres
    container_name: postgres
    restart: on-failure
    # set shared memory limit when using docker-compose
    shm_size: 128mb
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: senha
      POSTGRES_USER: usuario

  adminer:
    image: adminer
    restart: on-failure
    container_name: adminer
    ports:
      - 8080:8080

```

Para subir o banco de dados, basta rodar o comando `docker-compose up -d` na pasta onde está o arquivo `docker-compose.yml`. Para sistema de cache, vamos utilizar o Redis. Adicionar ele no `docker-compose.yml`:

```yaml
# Use postgres/example user/password credentials
version: '3.9'

services:

  db:
    image: postgres
    container_name: postgres
    restart: on-failure
    # set shared memory limit when using docker-compose
    shm_size: 128mb
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: senha
      POSTGRES_USER: usuario

  adminer:
    image: adminer
    restart: on-failure
    container_name: adminer
    ports:
      - 8080:8080

  redis:
    image: redis
    restart: on-failure
    container_name: redis
    ports:
      - "6379:6379"
```

Nesse `docker-compose.yml`, estamos nossa estrutura de banco e cache. Posteriormente, vamos adicionar o NGINX para servir nossa aplicação. 

## Implementação

Agora vem a etapa de implementação do projeto. Aqui vamos analisar a arquitetura proposta para a solução. Seu objetivo é implementar essa arquitetura.

:::info[Variações]

Essa arquitetura pode ser alterada. Se vocês forem implementar outra arquitetura, adicionar o diagrama dela.

:::

<iframe src="https://docs.google.com/presentation/d/e/2PACX-1vTbDSZO5_qqeTF8n5WBkqIHus38CB8WqS1t5WGIAlt8mqbAfaneIfG9DVO-xuNVd78RjoH90eOC9Q4x/embed?start=false&loop=false&delayms=3000" frameborder="0" width="960" height="569" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>
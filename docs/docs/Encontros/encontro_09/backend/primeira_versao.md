---
sidebar_position: 2
title: Backend Simples
---

import useBaseUrl from '@docusaurus/useBaseUrl';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Primeira Versão do Backend

Nossa primeira versão do backend é bastante simples. Ela possui um endpoint apenas e exibe o resultado de uma operação matemática. Ela vai receber a operação no corpo da requisição e retornar o resultado. Vamos para sua implementação.

## Criando ambiente de desenvolvimento

Pessoal vamos aqui criar nosso ambinte virtual para o desenvolvimento da nossa solução. Para isso, vamos utilizar o `venv` para criar um ambiente virtual para o nosso projeto.

```bash
python3 -m venv venv
```

Aqui temos um diretório chamado `venv` que é o nosso ambiente virtual. Para ativar ele, vamos utilizar o comando:

```bash
# No Linux/Mac
source venv/bin/activate
```

```bash
# No Windows
venv\Scripts\activate
```

## Instalando as dependências

Vamos adicionar agora as dependências do nosso projeto. Para isso, vamos criar um arquivo chamado `requirements.txt` e adicionar as dependências necessárias.

```bash
# requirements.txt
fastapi==0.111.0
plusminus==0.7.0
```

Na versão atual do FastAPI, o Uvicorn já é instalado por padrão. Mais informações [aqui](https://pypi.org/project/fastapi/).
O pacote `plusminus` é uma biblioteca que faz a operação matemática. Mais informações [aqui](https://pypi.org/project/plusminus/).

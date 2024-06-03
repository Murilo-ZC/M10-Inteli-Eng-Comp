---
sidebar_position: 5
title: Implementando Logs - Versão Base
---

import useBaseUrl from '@docusaurus/useBaseUrl';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Implementando o sistema de Logs - Versão Base

Agora vamos implementar o sistema de logs em nossa aplicação. Para isso, vamos compreender alguns conceitos importantes sobre logs utilizando o Python. Por padrão, o Python possui um módulo chamado `logging` que permite a criação de logs em um sistema.

Vamos adicionar o um arquivo chamado `logs.py` em `src`. Este arquivo será responsável por configurar o sistema de logs da nossa aplicação. 

***IMPORTANTE:*** Vamos trabalhar agora com o `sistema2`. Nesse momento ele é exatamente igual ao `sistema1`, mas precisamos criar novamente o `venv` e instalar as dependências. 


```python title="src/logs.py" showLineNumbers=true
# src/logs.py
import logging

logging.basicConfig(level=logging.DEBUG)

logger = logging.getLogger(__name__)

def log_info(message: str):
    logger.info(message)

def log_debug(message: str):
    logger.debug(message)

def log_warning(message: str):
    logger.warning(message)

def log_error(message: str):
    logger.error(message)

def log_critical(message: str):
    logger.critical(message)

```

Neste arquivo, importamos o módulo `logging` e configuramos o nível de logs para `DEBUG`. Em seguida, criamos um objeto `logger` que será utilizado para registrar as mensagens de log. Agora vamos alterar nosso arquivo `main.py` para utilizar o sistema de logs que acabamos de criar.

```python title="src/main.py" showLineNumbers=true
# src/main.py

from fastapi import FastAPI
from routers import usuarios, produtos
from logs import log_info

app = FastAPI()

app.include_router(usuarios.router)
app.include_router(produtos.router)

@app.get("/")
async def root():
    log_info("Acessando a rota /")
    return {"message": "Hello World"}

```

Agora vai ser possível visualizar as mensagens de log no terminal! Apenas quando a rota `/` for acessada, a mensagem `Acessando a rota /` será exibida no terminal.

> Murilo calma lá, construimos o projeto até aqui e ainda estamos com informações de log no console. Não tem outra forma de visualizar esses logs de uma forma mais organizada?

Sim, temos! Vamos configurar o `logging` para salvar as mensagens de log em um arquivo. Para isso, vamos alterar o arquivo `logs.py` para que ele crie um arquivo de log chamado `app.log` e salve as mensagens de log nele, dentro do diretório `logs`.

***IMPORTANTE:*** Não se esqueça de criar o diretório `logs` no mesmo nível que o `src` para que o arquivo de log seja criado corretamente. Outro ponto importante: o arquivo de log será criado no diretório `logs` e não no diretório `src`. E o ponto de execução do projeto é muito importante para que o arquivo de log seja criado no local correto. O projeto é executado a partir do diretório `sistema2`, então o arquivo de log será criado no diretório `logs` dentro do diretório `sistema2`.

```python title="src/logs.py" showLineNumbers=true
# src/logs.py
import logging

# Altera o arquivo de logs para salvar as mensagens em um arquivo
logging.basicConfig(filename='logs/app.log', level=logging.DEBUG)

logger = logging.getLogger(__name__)

def log_info(message: str):
    logger.info(message)

def log_debug(message: str):
    logger.debug(message)

def log_warning(message: str):
    logger.warning(message)

def log_error(message: str):
    logger.error(message)

def log_critical(message: str):
    logger.critical(message)

```

Boa!! Agora temos nosso sistema de logs configurado para salvar as mensagens de log no arquivo `app.log` dentro do diretório `logs`. Agora não dependemos mais do terminal para visualizar as mensagens de log! Mas, nossos logs ainda podem melhorar. Vamos adicionar algumas informações extras nas mensagens de log para que possamos identificar melhor o que está acontecendo em nossa aplicação.

```python title="src/logs.py" showLineNumbers=true
# src/logs.py

import logging

logging.basicConfig(filename='logs/app.log', level=logging.DEBUG, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

logger = logging.getLogger(__name__)

def log_info(message: str):
    logger.info(message)

def log_debug(message: str):
    logger.debug(message)

def log_warning(message: str):
    logger.warning(message)

def log_error(message: str):
    logger.error(message)

def log_critical(message: str):
    logger.critical(message)

```

Agora nossas mensagens estão sendo exibidas no seguinte formato:

```txt
2024-06-03 16:14:35,391 - logs - INFO - Acessando a rota /
2024-06-03 16:14:36,039 - logs - INFO - Acessando a rota /
2024-06-03 16:14:36,596 - logs - INFO - Acessando a rota /
```

Agora temos a data e hora em que a mensagem foi registrada, o nome do logger, o nível do log e a mensagem em si. Isso nos ajuda a identificar melhor o que está acontecendo em nossa aplicação. Mas ainda podemos melhorar ainda mais nossos logs. Vamos formatar nossas mensagens de log para que elas sejam armazenadas em um formato mais simples de ser lido.

```python title="src/logs.py" showLineNumbers=true
import logging

# Altera o formato das mensagens de log para guardar elas no formato de JSON
logging.basicConfig(filename='logs/app.log', level=logging.DEBUG, format='{"time": "%(asctime)s", "name": "%(name)s", "level": "%(levelname)s", "message": "%(message)s"}')


logger = logging.getLogger(__name__)

def log_info(message: str):
    logger.info(message)

def log_debug(message: str):
    logger.debug(message)

def log_warning(message: str):
    logger.warning(message)

def log_error(message: str):
    logger.error(message)

def log_critical(message: str):
    logger.critical(message)
```

Agora temos nossas mensagens de log no seguinte formato:

```json
{"time": "2024-06-03 16:14:35,391", "name": "logs", "level": "INFO", "message": "Acessando a rota /"}
{"time": "2024-06-03 16:14:36,039", "name": "logs", "level": "INFO", "message": "Acessando a rota /"}
{"time": "2024-06-03 16:14:36,596", "name": "logs", "level": "INFO", "message": "Acessando a rota /"}
```

Agora, com nossas mensagens sendo armazenadas em um formato JSON, podemos facilmente analisar e processar essas mensagens de log. Manter o log no formato JSON é uma prática comum em aplicações modernas, pois facilita a análise e o processamento dos logs.

> Murilo, legal, conseguimos guardar nossas mensagens, mas ainda tem mais informações que estão sendo armazenadas nesse log também, o que está acontecendo?

Isso mesmo! 

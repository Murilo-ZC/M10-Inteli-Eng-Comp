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

Vamos ajustar agora nosso logger para que ele possa ser configurado por um arquivo externo. Essa prática é muito comum em aplicações Python, pois permite que a configuração do logger seja feita de forma mais flexível e dinâmica.

Vamos criar um arquivo chamado `src/logging_config.py` e adicionar as seguintes configurações nele:

```python title="src/logging_config.py" showLineNumbers=true
# src/logging_config.py
import logging
import logging.handlers
import time

class LoggerSetup():

    def __init__(self):
        # Pega a instância do logger
        self.logger = logging.getLogger('')
        # Invoca o método que configura o logger
        self.setup_logging()

    def setup_logging(self):
        # Adiciona um formatador para o logger - utilizando a sintaxe de JSON
        LOG_FORMAT = '{"time": "%(asctime)s", "name": "%(name)s", "level": "%(levelname)s", "message": "%(message)s"}'
        # Setando o nível do log para INFO.
        logging.basicConfig(level=logging.INFO)
        # Adiciona o formatador ao logger
        formatter = logging.Formatter(LOG_FORMAT)

        # Adiciona um handler para que os dados armazenados no logger também possam ser exibidos na tela
        console=logging.StreamHandler()
        # Adiciona o formatador para o handler definido
        console.setFormatter(formatter)

        # Adiciona um gerenciador de rotação para o logs. Esse comportamento faz com que o arquivo que está sendo criado para guardar os logs possa ser alterado de acordo com o tamanho do arquivo ou o tempo de criação. Também é possível definir a quantidade de arquivos anteriores de logs serão armazenados.
        log_file = "logs/app.log"
        # Mais informações sobre a classe: https://docs.python.org/3/library/logging.handlers.html#timedrotatingfilehandler
        # Neste caso, estamos configurando nosso arquivo de log para ser rotacionado a cada 5 minutos, mantendo 3 arquivos anteriores.
        file = logging.handlers.TimedRotatingFileHandler(log_file, when='M', interval=5, backupCount=3)
        file.setFormatter(formatter)

        # Com os dois handlers criados, adicionamos eles ao logger
        self.logger.addHandler(console)
        self.logger.addHandler(file)

```

Agora ajustamos nosso arquivo `src/main.py` para utilizar nosso novo arquivo de configuração de logs.

```python title="src/main.py" showLineNumbers=true
# src/main.py

from fastapi import FastAPI, Request
from routers import usuarios, produtos
from logging_config import LoggerSetup
import logging

# Cria um logger raiz
logger_setup = LoggerSetup()

# Adiciona o logger para o módulo
LOGGER = logging.getLogger(__name__)

app = FastAPI()

app.include_router(usuarios.router)
app.include_router(produtos.router)

@app.get("/")
async def root(request:Request):
    LOGGER.info("Acessando a rota /")
    return {"message": "Hello World"}

```

> Opa! Calma ai Murilo, agora não tem mais um monte de mensagens aparecendo no arquivo! O que aconteceu?

Nós ajustamos o nível de mensagens de log para `INFO` no arquivo `logging_config.py`. Isso significa que apenas mensagens de log com nível `INFO` ou superior serão exibidas. Se quisermos exibir mensagens de log com nível `DEBUG`, precisamos ajustar o nível de log para `DEBUG` no arquivo `logging_config.py`.

Outro ponto importante, agora temos um arquivo de configuração de logs que pode ser ajustado de acordo com as necessidades da aplicação. Isso torna a configuração do logger mais flexível e dinâmica.

Outro ponto importante! Observe a lógica de backup do arquivo de log que criamos no arquivo `logging_config.py`. Neste caso, estamos configurando nosso arquivo de log para ser rotacionado a cada 5 minutos, mantendo 3 arquivos anteriores. Isso significa que a cada 5 minutos um novo arquivo de log será criado e os arquivos anteriores serão mantidos. Isso é útil para manter um histórico de logs e evitar que o arquivo de log fique muito grande.

## Adicionando Logs em Rotas

Agora vamos alterar nossos arquivos dos routers para adicionar mensagens de log em cada rota. Vamos começar pelo arquivo `usuarios.py`.

```python title="src/routers/usuarios.py" showLineNumbers=true
# routers/usuarios.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from schemas.usuarios import Usuario as UsuarioSchema
from services.usuarios import UsuarioService
from databases import database
import logging

#Cria o logger para o módulo
LOGGER = logging.getLogger(__name__)

router = APIRouter()

@router.get("/usuarios/{usuario_id}")
async def get_usuario(usuario_id: int, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /usuarios/{usuario_id}", "usuario_id": usuario_id, "method": "GET"})
    usuarioService = UsuarioService(db)
    return usuarioService.get(usuario_id)

@router.get("/usuarios")
async def get_usuarios(db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /usuarios", "method": "GET"})
    usuarioService = UsuarioService(db)
    return usuarioService.get_all()

@router.post("/usuarios")
async def create_usuario(usuario: UsuarioSchema, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /usuarios", "method": "POST", "usuario": usuario.dict()})
    usuarioService = UsuarioService(db)
    return usuarioService.add(usuario=usuario)

@router.put("/usuarios/{usuario_id}")
async def update_usuario(usuario_id: int, usuario: UsuarioSchema, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /usuarios/{usuario_id}", "method": "PUT", "usuario_id": usuario_id, "usuario": usuario.dict()})
    usuarioService = UsuarioService(db)
    return usuarioService.update(usuario_id, usuario=usuario)
    

@router.delete("/usuarios/{usuario_id}")
async def delete_usuario(usuario_id: int, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /usuarios/{usuario_id}", "method": "DELETE", "usuario_id": usuario_id})
    usuarioService = UsuarioService(db)
    return usuarioService.delete(usuario_id)
   
```

Observe que desta forma, adicionamos um comportamento de log em cada rota do arquivo `usuarios.py`. Isso nos permite identificar facilmente o que está acontecendo em cada rota e monitorar o comportamento da aplicação.

:::info[FatAPI Middleware]

Pessoal a resposta para a pergunta: "E se eu quiser adicionar logs em todas as rotas da minha aplicação?" é o FastAPI Middleware. O FastAPI Middleware é um recurso que permite adicionar comportamentos em todas as rotas da aplicação. Isso é útil para adicionar comportamentos comuns em todas as rotas, como logs, autenticação, etc.

E por sinal, esse é um dos desafios que devem ser implementados na atividade ponderada!

:::

Pessoal vamos agora adicionar o mesmo comportamento de log no arquivo `produtos.py`.

```python title="src/routers/produtos.py" showLineNumbers=true
# src/routers/produtos.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from schemas.produtos import Produto as ProdutoSchema
from services.produtos import ProdutoService
from databases import database
import logging

LOGGER = logging.getLogger(__name__)

router = APIRouter()

@router.get("/produtos/{produto_id}")
async def get_produto(produto_id: int, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /produtos/{produto_id}", "produto_id": produto_id, "method": "GET"})
    produtoService = ProdutoService(db)
    return produtoService.get(produto_id)

@router.get("/produtos")
async def get_produtos(db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /produtos", "method": "GET"})
    produtoService = ProdutoService(db)
    return produtoService.get_all()

@router.post("/produtos")
async def create_produto(produto: ProdutoSchema, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /produtos", "method": "POST", "produto": produto.dict()})
    produtoService = ProdutoService(db)
    return produtoService.add(produto=produto)

@router.put("/produtos/{produto_id}")
async def update_produto(produto_id: int, produto: ProdutoSchema, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /produtos/{produto_id}", "method": "PUT", "produto_id": produto_id, "produto": produto.dict()})
    produtoService = ProdutoService(db)
    return produtoService.update(produto_id, produto=produto)
    

@router.delete("/produtos/{produto_id}")
async def delete_produto(produto_id: int, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /produtos/{produto_id}", "method": "DELETE", "produto_id": produto_id})
    produtoService = ProdutoService(db)
    return produtoService.delete(produto_id)
```

Agora temos todas as nossas mensagens de log configuradas no nosso sistema! Isso nos permite monitorar o comportamento da aplicação e identificar facilmente o que está acontecendo em cada rota 🐞☕️.

Contudo, ainda não vamos parar aqui! Esses logs precisam ser processados! E como podemos fazer isso?

Me acompanhem na próxima seção!


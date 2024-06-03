---
sidebar_position: 4
title: Implementando Logs
---

import useBaseUrl from '@docusaurus/useBaseUrl';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Implementando o sistema de Logs

Primeiro vamos definir a estrutura da nossa aplicação. Ela vai ser composta por 2 CRUDs, um para usuários e outro para produtos. Vamos primeiro realizar essa implementação localmente e depois migrar ela para um container Docker e algumas coisitas amais.

### Estrutura da aplicação local

Vamos criar um ambiente virtual para implementar nossa aplicação. Vamos criar ele com o `venv` do Python.

```bash
python3 -m venv venv
source venv/bin/activate
```

Importante a forma da ativação acima é válida para sistemas Unix. Para sistemas Windows, ativar o script de ativação do ambiente virtual. Vamos agora criar nosso arquivo de dependências e já adicionar o `FastAPI`, o `SQLAlchemy` e o `Alembic`. Primeiro vamos conectar nossa aplicação em um banco SQLite.

```bash
fastapi==0.111.0
SQLAlchemy==2.0.30
alembic==1.13.1
```

Agora vamos mandar instalar essas dependências.

```bash
python3 -m pip install -r requirements.txt
```

> Calma Murilo! O que é esse `Alembic`?

O `Alembic` é uma ferramenta de migração de banco de dados para o SQLAlchemy. Ele é responsável por criar e gerenciar as migrações do banco de dados. Ele é uma ferramenta muito útil para manter a consistência do banco de dados em ambientes de desenvolvimento, teste e produção. 

O que ele faz é criar um arquivo de migração que contém as alterações que você deseja fazer no banco de dados. Por exemplo, se você deseja adicionar uma nova coluna a uma tabela, o `Alembic` cria um arquivo de migração que contém o código SQL para adicionar essa coluna. Desta forma, a criação dos nossos bancos e mudanças de estrutura vão ser feitas de forma automática. Mais informações sobre o `Alembic` podem ser encontradas [aqui](https://alembic.sqlalchemy.org/en/latest/front.html#project-homepage).

:::note[Migrations]

As migrações são uma forma de manter o controle das alterações no banco de dados. Elas são úteis para garantir que as alterações feitas no banco de dados sejam consistentes e reversíveis. As migrações são especialmente úteis em ambientes de desenvolvimento, onde as alterações no banco de dados são frequentes.

<iframe width="560" height="315" src="https://www.youtube.com/embed/HRw1Dcxxu2k?si=FIeIs41HNw6N-hkD" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

:::

### Utilizando o Alembic e Migrations

Agora, dentro do diretório `src` da nossa aplicação, vamos criar nosso arquivo de aplicação `main.py`. Ele vai ser composto por um CRUD de usuários e um CRUD de produtos. Os modelos para esses CRUDs vão ser definidos no arquivo `models/base.py`, `models/usuarios.py` e `models/produtos.py`.

```python title="models/base.py" showLineNumbers=true
# base.py

from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
```

```python title="models/usuarios.py" showLineNumbers=true
# usuarios.py
from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from .base import Base

class Usuario(Base):
    __tablename__ = 'usuarios'

    id = Column(Integer, primary_key=True, autoincrement=True)
    nome = Column(String)
    email = Column(String)
    senha = Column(String)
    data_criacao = Column(DateTime)
    data_modificacao = Column(DateTime)

    def __repr__(self):
        return f"<Usuario(nome='{self.nome}', email='{self.email}, id={self.id}', criado_em='{self.data_criacao}', modificado_em='{self.data_modificacao}')>"
```

Agora o arquivo `models/produtos.py`.

```python title="models/produtos.py" showLineNumbers=true
# produtos.py
from sqlalchemy import Column, Integer, String, Double, DateTime
from sqlalchemy.ext.declarative import declarative_base
from .base import Base

class Produto(Base):
    __tablename__ = 'produtos'

    id = Column(Integer, primary_key=True, autoincrement=True)
    nome = Column(String)
    descricao = Column(String)
    preco = Column(Double)
    data_criacao = Column(DateTime)
    data_modificacao = Column(DateTime)

    def __repr__(self):
        return f"<Produto(nome='{self.nome}', descricao='{self.descricao}, id={self.id}', criado_em='{self.data_criacao}', modificado_em='{self.data_modificacao}')>"
```

Agora precisamos utilizar o `Alembic` para criar as migrações do banco de dados. Na raiz da nossa aplicação, vamos executar o comando `alembic init alembic`. Isso vai criar um diretório `alembic` com os arquivos de configuração do `Alembic`.

```bash
alembic init alembic
```

Esse comando vai criar um diretório `alembic` com os arquivos de configuração do `Alembic`. Agora vamos configurar o `Alembic` para utilizar o banco de dados SQLite. Para isso, vamos editar o arquivo `alembic.ini` e adicionar a URL de conexão do banco de dados.
Vamos editar o arquivo `alembic.ini` e adicionar a URL de conexão do banco de dados.

```bash title="alembic.ini" showLineNumbers=true
# A generic, single database configuration.

[alembic]
# path to migration scripts
script_location = alembic

# template used to generate migration file names; The default value is %%(rev)s_%%(slug)s
# Uncomment the line below if you want the files to be prepended with date and time
# see https://alembic.sqlalchemy.org/en/latest/tutorial.html#editing-the-ini-file
# for all available tokens
# file_template = %%(year)d_%%(month).2d_%%(day).2d_%%(hour).2d%%(minute).2d-%%(rev)s_%%(slug)s

# sys.path path, will be prepended to sys.path if present.
# defaults to the current working directory.
prepend_sys_path = .

# timezone to use when rendering the date within the migration file
# as well as the filename.
# If specified, requires the python>=3.9 or backports.zoneinfo library.
# Any required deps can installed by adding `alembic[tz]` to the pip requirements
# string value is passed to ZoneInfo()
# leave blank for localtime
# timezone =

# max length of characters to apply to the
# "slug" field
# truncate_slug_length = 40

# set to 'true' to run the environment during
# the 'revision' command, regardless of autogenerate
# revision_environment = false

# set to 'true' to allow .pyc and .pyo files without
# a source .py file to be detected as revisions in the
# versions/ directory
# sourceless = false

# version location specification; This defaults
# to alembic/versions.  When using multiple version
# directories, initial revisions must be specified with --version-path.
# The path separator used here should be the separator specified by "version_path_separator" below.
# version_locations = %(here)s/bar:%(here)s/bat:alembic/versions

# version path separator; As mentioned above, this is the character used to split
# version_locations. The default within new alembic.ini files is "os", which uses os.pathsep.
# If this key is omitted entirely, it falls back to the legacy behavior of splitting on spaces and/or commas.
# Valid values for version_path_separator are:
#
# version_path_separator = :
# version_path_separator = ;
# version_path_separator = space
version_path_separator = os  # Use os.pathsep. Default configuration used for new projects.

# set to 'true' to search source files recursively
# in each "version_locations" directory
# new in Alembic version 1.10
# recursive_version_locations = false

# the output encoding used when revision files
# are written from script.py.mako
# output_encoding = utf-8

sqlalchemy.url = sqlite:///database.db


[post_write_hooks]
# post_write_hooks defines scripts or Python functions that are run
# on newly generated revision scripts.  See the documentation for further
# detail and examples

# format using "black" - use the console_scripts runner, against the "black" entrypoint
# hooks = black
# black.type = console_scripts
# black.entrypoint = black
# black.options = -l 79 REVISION_SCRIPT_FILENAME

# lint with attempts to fix using "ruff" - use the exec runner, execute a binary
# hooks = ruff
# ruff.type = exec
# ruff.executable = %(here)s/.venv/bin/ruff
# ruff.options = --fix REVISION_SCRIPT_FILENAME

# Logging configuration
[loggers]
keys = root,sqlalchemy,alembic

[handlers]
keys = console

[formatters]
keys = generic

[logger_root]
level = WARN
handlers = console
qualname =

[logger_sqlalchemy]
level = WARN
handlers =
qualname = sqlalchemy.engine

[logger_alembic]
level = INFO
handlers =
qualname = alembic

[handler_console]
class = StreamHandler
args = (sys.stderr,)
level = NOTSET
formatter = generic

[formatter_generic]
format = %(levelname)-5.5s [%(name)s] %(message)s
datefmt = %H:%M:%S

```

Agora vamos configurar o `Alembic` para utilizar nossos modelos. Para isso, vamos criar um arquivo `__init__.py` dentro do diretório `src/models` e adicionar o seguinte código.

```python title="src/models/__init__.py" showLineNumbers=true
# __init__.py
from .usuarios import Usuario
from .produtos import Produto
from .base import Base

__all__ = ['Base', 'Usuario', 'Produto']

```

O que estamos fazendo aqui é importar os modelos `Base`, `Usuario` e `Produto` e exportá-los para que o `Alembic` possa utilizá-los. Agora vamos criar as migrações do banco de dados. Para isso, vamos editar o arquivo `alembic/env.py`, para adicionar onde estão nossos modelos. 

```python title="alembic/env.py" showLineNumbers=true
from logging.config import fileConfig

from sqlalchemy import engine_from_config
from sqlalchemy import pool

from src.models import *

from alembic import context

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

# Interpret the config file for Python logging.
# This line sets up loggers basically.
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# add your model's MetaData object here
# for 'autogenerate' support
# from myapp import mymodel
# target_metadata = mymodel.Base.metadata
target_metadata = Base.metadata

# other values from the config, defined by the needs of env.py,
# can be acquired:
# my_important_option = config.get_main_option("my_important_option")
# ... etc.


def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode.

    This configures the context with just a URL
    and not an Engine, though an Engine is acceptable
    here as well.  By skipping the Engine creation
    we don't even need a DBAPI to be available.

    Calls to context.execute() here emit the given string to the
    script output.

    """
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """Run migrations in 'online' mode.

    In this scenario we need to create an Engine
    and associate a connection with the context.

    """
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()

```


Agora vamos executar o comando `alembic revision --autogenerate -m "Initial migration"`.

```bash
alembic revision --autogenerate -m "Initial migration"
```

O que estamos fazendo aqui:

- `alembic revision`: Cria uma nova revisão.
- `--autogenerate`: Gera a revisão automaticamente com base nas diferenças entre o modelo e o banco de dados.
- `-m "Initial migration"`: Adiciona uma mensagem à revisão.

Agora vamos aplicar as migrações ao banco de dados.

```bash
alembic upgrade head
```

O que estamos fazendo aqui:

- `alembic upgrade head`: Aplica todas as migrações ao banco de dados.

Pronto! Agora temos nosso banco de dados criado e nossos modelos configurados. E com uma vantagem: se precisarmos fazer alguma alteração no banco de dados, podemos criar uma nova migração e aplicá-la ao banco de dados. Assim, da mesma maneira que temos o controle sobre as versões do nosso código, também temos o controle sobre as versões do nosso banco de dados.

### Implementando o CRUD de usuários


:::danger[Atenção - SQLAlchemy ORM vs Pydantic]

Pessoal aqui precisamos tomar algum cuidado com os elementos da nossa aplicação. O que construimos até aqui foi a estrutura do nosso banco de dados e a forma como ele vai ser acessado. Agora vamos implementar o CRUD de usuários. Para isso, vamos utilizar o `FastAPI` e o `Pydantic`. O `Pydantic` é uma biblioteca que nos ajuda a validar e serializar dados. Ele é muito útil para garantir que os dados que recebemos na nossa aplicação sejam válidos e estejam no formato correto. 

O que precisa estar claro para nós nesse momento é que o `SQLAlchemy ORM` é uma ferramenta para mapear objetos Python para tabelas de banco de dados. Já o `Pydantic` é uma ferramenta para validar e serializar dados. Eles NÃO SÃO A MESMA COISA!!!

Portanto, mesmo que nossa aplicação já possua os modelos de usuários, precisamos criar um modelo de usuário para o `Pydantic`. Isso porque o modelo de usuário do `SQLAlchemy ORM` é um modelo de banco de dados, enquanto o modelo de usuário do `Pydantic` é um modelo de dados.

:::

Legal, agora temos nosso banco estruturado e nossa aplicação pronta para receber os dados. Vamos implementar o CRUD de usuários. Antes disso, vamos criar os esquemas de validação dos nossos usuários. Eles vão ser definidos no arquivo `schemas/usuarios.py`.

```python title="src/schemas/usuarios.py" showLineNumbers=true
# schemas/usuarios.py

from pydantic import BaseModel
from datetime import datetime

class Usuario(BaseModel):
    id: int
    nome: str
    email: str
    senha: str
    data_criacao: datetime
    data_modificacao: datetime

    class Config:
        orm_mode = True
```

O que temos de diferente do nosso modelo de usuário do `SQLAlchemy ORM` é a classe `Config`. Ela é responsável por dizer ao `Pydantic` que o modelo `Usuario` é um modelo de dados e que ele deve ser serializado para ser retornado na resposta da nossa API.

Legal, mas ainda precisamos acessar nosso banco de dados! Até aqui precisamos ter a estrutura da nossa aplicação muito clara para nós:

- `models`: Onde estão os modelos do nosso banco de dados. Esses modelos foram utilizados pelo ORM para criar as tabelas no banco de dados. Essas tabelas estão sendo criadas utilizando o `Alembic`. Isso é realizado para mantermos o controle das versões do nosso banco de dados.
- `schemas`: Onde estão os modelos de dados da nossa aplicação. Esses modelos são utilizados para validar e serializar os dados que recebemos na nossa API. Eles são utilizados pelo `Pydantic`. Esse formato é utilizado pelo `FastAPI` para definir o formato dos dados que são recebidos e retornados pela nossa API.

Agora vamos criar os elementos responsáveis por acessar o nosso banco de dados. Vamos utilizar dois padrões de projetos para realizar essa operação: o `Repository Pattern` e o `Service Pattern`. O `Repository Pattern` é responsável por abstrair o acesso ao banco de dados. Ele é responsável por realizar as operações de leitura, escrita, atualização e exclusão dos dados. O `Service Pattern` é responsável por abstrair a lógica de negócio da nossa aplicação. Ele é responsável por realizar as operações de validação, tratamento de erros e chamadas a outros serviços.

É essencial que fique no nosso mapa mental da aplicação: ***quem vai manipular os dados é o `Repository Pattern`, quem vai dar o acesso a ele é o `Service Pattern`***.

:::note[Repository Pattern e Service Pattern]

Pessoal para conhecer melhor esses dois elementos, recomendo a leitura dos artigos:

- [Design Patterns in Python: Repository Pattern](https://medium.com/@okanyenigun/design-patterns-in-python-repository-pattern-1c2e5070a01c)
- [Fast API — Repository Pattern and Service Layer](https://medium.com/@kacperwlodarczyk/fast-api-repository-pattern-and-service-layer-dad43354f07a)

<iframe width="560" height="315" src="https://www.youtube.com/embed/9ymRLDfnDKg?si=Qs-uGHUmMqOjCKd2" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

:::

Vamos criar o diretório `src/repositories` e dentro dele vamos criar o arquivo `usuarios.py`.

```python title="src/repositories/usuarios.py" showLineNumbers=true
# src/repository/usuarios.py

from models.usuarios import Usuario
from sqlalchemy.orm import Session
from datetime import datetime

class UsuarioRepository:
    def __init__(self, db: Session):
        self.db = db

    def get(self, usuario_id):
        return self.db.query(Usuario).get(usuario_id)

    def get_all(self):
        return self.db.query(Usuario).all()

    def add(self, usuario: Usuario):
        usuario.id = None
        usuario.data_criacao = datetime.now()
        self.db.add(usuario)
        self.db.flush()
        self.db.commit()
        return {"message": "Usuário cadastrado com sucesso"}

    def update(self, usuario_id, usuario):
        usuariodb = self.db.query(Usuario).filter(Usuario.id == usuario_id).first()
        if usuariodb is None:
            return {"message": "Usuário não encontrado"}
        usuario.data_modificacao = datetime.now()
        usuario = usuario.__dict__
        usuario.pop("_sa_instance_state")
        usuario.pop("data_criacao")
        usuario.pop("id")
        self.db.query(Usuario).filter(Usuario.id == usuario_id).update(usuario)
        self.db.flush()
        self.db.commit()
        return {"message": "Usuário atualizado com sucesso"}

    def delete(self, usuario_id):
        usuariodb = self.db.query(Usuario).filter(Usuario.id == usuario_id).first()
        if usuariodb is None:
            return {"message": "Usuário não encontrado"}
        self.db.query(Usuario).filter(Usuario.id == usuario_id).delete()
        self.db.flush()
        self.db.commit()
        return {"message": "Usuário deletado com sucesso"}
        
```

Para facilitar a conexão com o banco de dados, vamos criar o arquivo `src/databases/database.py`:

```python title="src/databases/database.py" showLineNumbers=true
# src/databases/database.py
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine

SQLALCHEMY_DATABASE_URL = "sqlite:///database.db"

engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=True, bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

O que estamos fazendo aqui:

- `SQLALCHEMY_DATABASE_URL`: URL de conexão com o banco de dados. Define onde o banco está localizado.
- `engine`: Cria uma instância do `Engine` do SQLAlchemy. O `Engine` é responsável por se conectar ao banco de dados e executar as queries. O `connect_args={"check_same_thread": False}` é utilizado para permitir que o SQLite seja utilizado em ambientes multi-thread.
- `SessionLocal`: Cria uma instância do `SessionLocal` do SQLAlchemy. O `SessionLocal` é responsável por criar uma sessão do banco de dados. A sessão é utilizada para realizar as operações de leitura, escrita, atualização e exclusão dos dados.
- `get_db()`: Cria uma função que retorna uma sessão do banco de dados. Essa função é utilizada para criar uma sessão do banco de dados e fechá-la após o uso. O `yield` é utilizado com o objetivo de criar um gerador. O gerador é utilizado para criar uma sessão do banco de dados e fechá-la após o uso.

Agora vamos criar o nosso serviço que vai dar acesso ao nosso repositório de usuários. Importante notar aqui que a camada de serviço tem por objetivo trazer a lógica de negócio da nossa aplicação. Vamos criar o arquivo `src/services/usuarios.py`.

```python title="src/services/usuarios.py" showLineNumbers=true
# src/services/usuarios.py

from fastapi import HTTPException
from sqlalchemy.orm import Session
from repository.usuarios import UsuarioRepository
from models.usuarios import Usuario
from schemas.usuarios import Usuario as UsuarioSchema

class UsuarioService:
    def __init__(self, db: Session):
        self.repository = UsuarioRepository(db)

    def get(self, usuario_id):
        usuario = self.repository.get(usuario_id)
        if usuario is None:
            raise HTTPException(status_code=404, detail="Usuario não encontrado")
        return usuario

    def get_all(self):
        return self.repository.get_all()

    def add(self, usuario : UsuarioSchema):
        usuario = Usuario(**usuario.dict())
        return self.repository.add(usuario)

    def update(self, usuario_id, usuario : UsuarioSchema):
        usuario = Usuario(**usuario.dict())
        return self.repository.update(usuario_id, usuario)

    def delete(self, usuario_id):
        return self.repository.delete(usuario_id)
```

### Adicionando rotas para acessar o CRUD de usuários

Vamos criar um diretório `src/routers` e dentro dele vamos criar o arquivo `usuarios.py`. A abordagem de utilizar o diretório `routers` serve para separar as rotas da nossa aplicação. Cada conjunto de rotas vai ser definido em um arquivo separado.


```python title="src/routers/usuarios.py" showLineNumbers=true
# routers/usuarios.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from schemas.usuarios import Usuario as UsuarioSchema
from services.usuarios import UsuarioService
from databases import database

router = APIRouter()

@router.get("/usuarios/{usuario_id}")
async def get_usuario(usuario_id: int, db: Session = Depends(database.get_db)):
    usuarioService = UsuarioService(db)
    return usuarioService.get(usuario_id)

@router.get("/usuarios")
async def get_usuarios(db: Session = Depends(database.get_db)):
    usuarioService = UsuarioService(db)
    return usuarioService.get_all()

@router.post("/usuarios")
async def create_usuario(usuario: UsuarioSchema, db: Session = Depends(database.get_db)):
    usuarioService = UsuarioService(db)
    return usuarioService.add(usuario=usuario)

@router.put("/usuarios/{usuario_id}")
async def update_usuario(usuario_id: int, usuario: UsuarioSchema, db: Session = Depends(database.get_db)):
    usuarioService = UsuarioService(db)
    return usuarioService.update(usuario_id, usuario=usuario)
    

@router.delete("/usuarios/{usuario_id}")
async def delete_usuario(usuario_id: int, db: Session = Depends(database.get_db)):
    usuarioService = UsuarioService(db)
    return usuarioService.delete(usuario_id)
      
```

Agora vamos criar o arquivo `src/main.py`. Esse arquivo vai ser responsável por criar a nossa aplicação e definir as rotas da nossa API.

```python title="src/main.py" showLineNumbers=true
# src/main.py

from fastapi import FastAPI
from routers import usuarios

app = FastAPI()

app.include_router(usuarios.router)
```

Agora vamos executar nossa aplicação:

```bash
fastapi dev src/main.py
```

Fizemos muitas coisas aqui, vamos avaliar elas agora:

- Avaliando o `src/services/usuarios.py`: Aqui definimos a lógica de negócio da nossa aplicação. O serviço `UsuarioService` é responsável por abstrair a lógica de negócio da nossa aplicação. Ele é responsável por realizar as operações de validação, tratamento de erros e chamadas a outros serviços.
- Avaliando o `src/repositories/usuarios.py`: Aqui definimos o acesso ao banco de dados. O repositório `UsuarioRepository` é responsável por abstrair o acesso ao banco de dados. Ele é responsável por realizar as operações de leitura, escrita, atualização e exclusão dos dados.
- Avaliando o `src/routers/usuarios.py`: Aqui definimos as rotas da nossa aplicação. O roteador `usuarios` é responsável por definir as rotas da nossa aplicação. Ele é responsável por receber as requisições HTTP e chamar os métodos do serviço `UsuarioService`.

Pessoal, aqui fizemos uma abordagem um pouco diferente, construimos todo nosso ambiente para testar o CRUD de usuários. Por que não continuamos e implementamos o CRUD de produtos? Mesmo que os dois CRUDs, nesse momento, sejam muito parecidos, nosso objetivo foi de conseguir testar nossa aplicação. Lembrem-se sempre da máxima, quanto antes testarmos nossa aplicação, mais cedo vamos encontrar os problemas.

Agora vamos implementar o CRUD de produtos.

### Implementando o CRUD de produtos

Vamos criar o arquivo `schemas/produtos.py` para definir o modelo de dados dos produtos.

```python title="src/schemas/produtos.py" showLineNumbers=true
# schemas/produtos.py

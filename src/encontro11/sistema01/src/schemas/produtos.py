# schemas/produtos.py

from pydantic import BaseModel
from datetime import datetime

class Produto(BaseModel):
    id: int
    nome: str
    email: str
    senha: str
    data_criacao: datetime
    data_modificacao: datetime

    class Config:
        orm_mode = True
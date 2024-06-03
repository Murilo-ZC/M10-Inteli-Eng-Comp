# src/main.py

from fastapi import FastAPI
from routers import usuarios, produtos

app = FastAPI()

app.include_router(usuarios.router)
app.include_router(produtos.router)

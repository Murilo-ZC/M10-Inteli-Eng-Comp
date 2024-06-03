# src/main.py

from fastapi import FastAPI, Request
from routers import usuarios, produtos
from logs import log_info

app = FastAPI()

app.include_router(usuarios.router)
app.include_router(produtos.router)

@app.get("/")
async def root(request:Request):
    log_info("Acessando a rota /")
    return {"message": "Hello World"}

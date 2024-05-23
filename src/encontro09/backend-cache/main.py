# main.py

from fastapi import FastAPI
from pydantic import BaseModel
from cache import redis_client

# Define a classe de modelo base utilizada
class Pedido(BaseModel):
    expressao:str

app = FastAPI()

@app.post("/evaluate")
async def evaluate(pedido: Pedido):
    # Verifica se a requisição já foi feita
    resultado = redis_client.get(pedido.expressao)
    if resultado:
        return {"resultado": resultado.decode()}
    
    # Calcula o resultado da expressão
    try:
        resultado = eval(pedido.expressao)
        # Armazena o resultado no cache
        redis_client.set(pedido.expressao, resultado)
        return {"resultado": resultado}
    except Exception as e:
        # Em caso de erro, retorna uma mensagem de erro, mas armazena ela no cache também
        redis_client.set(pedido.expressao, f"Erro na expressão informada: {e}")
        return {"resultado": f"Erro na expressão informada: {e}"}
# main.py

from fastapi import FastAPI
from pydantic import BaseModel

# Define a classe de modelo base utilizada
class Pedido(BaseModel):
    expressao:str

app = FastAPI()

@app.post("/evaluate")
async def evaluate(pedido: Pedido):
    # Esta versão ainda não utiliza a biblioteca plusminus para verificar a expressão
    # Ela faz a verificação apenas com a função eval do Python
    try:
        resultado = eval(pedido.expressao)
        return {"resultado": resultado}
    except Exception as e:
        return {"resultado": f"Erro na expressão informada: {e}"}
    

    
    
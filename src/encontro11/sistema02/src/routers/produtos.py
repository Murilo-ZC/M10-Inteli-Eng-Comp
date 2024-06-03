# src/routers/produtos.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from schemas.produtos import Produto as ProdutoSchema
from services.produtos import ProdutoService
from databases import database

router = APIRouter()

@router.get("/produtos/{produto_id}")
async def get_produto(produto_id: int, db: Session = Depends(database.get_db)):
    produtoService = ProdutoService(db)
    return produtoService.get(produto_id)

@router.get("/produtos")
async def get_produtos(db: Session = Depends(database.get_db)):
    produtoService = ProdutoService(db)
    return produtoService.get_all()

@router.post("/produtos")
async def create_produto(produto: ProdutoSchema, db: Session = Depends(database.get_db)):
    produtoService = ProdutoService(db)
    return produtoService.add(produto=produto)

@router.put("/produtos/{produto_id}")
async def update_produto(produto_id: int, produto: ProdutoSchema, db: Session = Depends(database.get_db)):
    produtoService = ProdutoService(db)
    return produtoService.update(produto_id, produto=produto)
    

@router.delete("/produtos/{produto_id}")
async def delete_produto(produto_id: int, db: Session = Depends(database.get_db)):
    produtoService = ProdutoService(db)
    return produtoService.delete(produto_id)
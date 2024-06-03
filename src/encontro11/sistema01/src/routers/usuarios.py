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
   
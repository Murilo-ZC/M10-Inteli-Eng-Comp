# routers/usuarios.py

from fastapi import APIRouter, HTTPException
from models.usuarios import Usuario as UsuarioDB
from schemas.usuarios import Usuario as UsuarioSchema

router = APIRouter()

@router.get("/usuarios/{usuario_id}")
async def get_usuario(usuario_id: int):
    usuario = UsuarioDB.get(usuario_id)
    if usuario is None:
        raise HTTPException(status_code=404, detail="Usuario não encontrado")
    return usuario

@router.get("/usuarios")
async def get_usuarios():
    return UsuarioDB.get_all()

@router.post("/usuarios")
async def create_usuario(usuario: UsuarioSchema):
    usuario.save()
    return usuario

@router.put("/usuarios/{usuario_id}")
async def update_usuario(usuario_id: int, usuario: UsuarioSchema):
    usuario.update(usuario_id)
    return usuario

@router.delete("/usuarios/{usuario_id}")
async def delete_usuario(usuario_id: int):
    usuario = UsuarioDB.get(usuario_id)
    if usuario is None:
        raise HTTPException(status_code=404, detail="Usuario não encontrado")
    usuario.delete()
    return usuario
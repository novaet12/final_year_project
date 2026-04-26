from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
import models, schemas

router = APIRouter()

@router.get("/posts")
def get_posts(db: Session = Depends(get_db)):
    return db.query(models.ForumPost).all()

@router.post("/posts")
def create_post(post: schemas.PostCreate, db: Session = Depends(get_db)):
    db_post = models.ForumPost(
        title=post.title, 
        content=post.content, 
        alias=post.alias or "Anonymous"
    )
    db.add(db_post)
    db.commit()
    db.refresh(db_post)
    return db_post
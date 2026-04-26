from sqlalchemy import Column, Integer, String, Text
from database import Base

class ForumPost(Base):
    __tablename__ = "forum_posts"
    id = Column(Integer, primary_key=True, index=True)
    alias = Column(String, default="Anonymous")
    title = Column(String)
    content = Column(Text)
    likes = Column(Integer, default=0)
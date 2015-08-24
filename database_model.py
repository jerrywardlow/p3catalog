from sqlalchemy import Column, ForeignKey, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, backref
from sqlalchemy import create_engine
from datetime import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    email = Column(String)
    picture = Column(String)


class Category(Base):
    __tablename__ = 'categories'

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    description = Column(String, nullable=False)
    photo = Column(String)
    created = Column(DateTime, default = datetime.now)
    user_id = Column(Integer, ForeignKey('users.id'))
    user = relationship(User)

    @property
    def serialize(self):
        """Return object data in easily serializeable format"""
        return {
            'name': self.name,
            'description': self.description,
            'id': self.id,
            'photo': self.photo,
            'user_id': self.user_id,
            'created': self.created,
        }

class Item(Base):
    __tablename__ = 'items'

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    description = Column(String, nullable=False)
    photo = Column(String)
    created = Column(DateTime, default = datetime.now)
    category_id = Column(Integer, ForeignKey('categories.id'))
    ###category = relationship(Category)
    user_id = Column(Integer, ForeignKey('users.id'))
    user = relationship(User)
    category = relationship(Category, single_parent=True, cascade='all, delete')

    @property
    def serialize(self):
        """Return object data in easily serializeable format"""
        return {
            'name': self.name,
            'description': self.description,
            'id': self.id,
            'photo': self.photo,
            'category_id': self.category_id,
            'user_id': self.user_id,
            'created': self.created,
        }

engine = create_engine('postgresql:///itemcatalog')
Base.metadata.create_all(engine)

from . import db

from datetime import datetime

from flask_login import UserMixin

class User(db.Model, UserMixin):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    email = db.Column(db.String)
    picture = db.Column(db.String)

class Category(db.Model):
    __tablename__ = 'categories'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    photo = db.Column(db.String)
    created = db.Column(db.DateTime, default = datetime.now)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    user = db.relationship(User)

    @property
    def serialize(self):
        '''Object data in easily serialized format for endpoints'''
        return {
            'name': self.name,
            'description': self.description,
            'id': self.id,
            'photo': self.photo,
            'user_id': self.user_id,
            'created': self.created,
        }

class Item(db.Model):
    __tablename__ = 'items'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    photo = db.Column(db.String)
    created = db.Column(db.DateTime, default = datetime.now)
    category_id = db.Column(db.Integer, db.ForeignKey('categories.id',
                                                      ondelete='CASCADE'))
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    user = db.relationship(User)
    category = db.relationship(Category)

    @property
    def serialize(self):
        '''Object data in easily serialized format for endpoints'''
        return {
            'name': self.name,
            'description': self.description,
            'id': self.id,
            'photo': self.photo,
            'category_id': self.category_id,
            'user_id': self.user_id,
            'created': self.created,
        }

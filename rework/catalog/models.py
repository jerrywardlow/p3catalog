from . import db

class Category(db.Model):
    __tablename__ = 'categories'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    photo = db.Column(db.String)
    created = db.Column(db.DateTime, default = datetime.now)
    user_id = db.Column(db.Integer, ForeignKey('users.id'))
    user = db.relationship(User)

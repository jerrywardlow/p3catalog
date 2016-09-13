from flask import render_template

from catalog import app, db

from .models import User, Category, Item

@app.route('/')
@app.route('/index')
def index():
    categories = Category.query.order_by(asc(Category.name))
    items = Item.query.order_by(desc(Item.created)).limit(4).all()
    pass

from flask import render_template

from catalog import app, db

from .models import User, Category, Item

@app.route('/')
@app.route('/index')
def index():
    categories = Category.query.order_by(asc(Category.name))
    items = Item.query.order_by(desc(Item.created)).limit(4).all()
    pass

@app.route('/categories/')
def categories():
    categories = Category.query.order_by(asc(Category.name))
    pass

@app.route('/category/<int:category_id>/')
def category(category_id):
    categories = Category.query.order_by(asc(Category.name))
    category = Category.query.filter_by(id=category_id).first()
    items = Item.query.filter_by(category_id=category_id).all()
    pass

from flask import render_template

from catalog import app, db

from .models import User, Category, Item

CATEGORIES_QUERY = Category.query.order_by(asc(Category.name))

@app.route('/')
@app.route('/index')
def index():
    categories = CATEGORIES_QUERY
    items = Item.query.order_by(desc(Item.created)).limit(4).all()
    pass

@app.route('/categories/')
def categories():
    categories = CATEGORIES_QUERY
    pass

@app.route('/category/<int:category_id>/')
def category(category_id):
    categories = CATEGORIES_QUERY
    category = Category.query.filter_by(id=category_id).first()
    items = Item.query.filter_by(category_id=category_id).all()
    pass
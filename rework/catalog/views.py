from flask import render_template

from catalog import app, db

from .models import User, Category, Item

CATEGORIES_QUERY = Category.query.order_by(Category.name.asc())

@app.route('/')
@app.route('/index')
def index():
    categories = CATEGORIES_QUERY
    items = Item.query.order_by(Item.created.desc()).limit(4).all()
    return "index"

@app.route('/categories/')
def categories():
    categories = CATEGORIES_QUERY
    return "categories"

@app.route('/category/<int:category_id>/')
@app.route('/category/<int:category_id>/home')
def category(category_id):
    categories = CATEGORIES_QUERY
    category = Category.query.filter_by(id=category_id).first()
    items = Item.query.filter_by(category_id=category_id).all()
    return "category/" + category_id

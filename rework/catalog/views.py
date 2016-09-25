from flask import redirect, render_template, request, url_for

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

@app.route('/category/add/', methods=['GET', 'POST'])
def category_add():
    categories = CATEGORIES_QUERY
    if request.method == 'POST':
        category = Category(name='test name',
                            description='test description',
                            user_id = 1)
        if request.files['image']:
            category.photo = "***Placeholder for imgur_upload() output***"
        db.session.add(category)
        flash("New Category '%s' Successfully Added" % category.name)
        db.session.commit()
        return redirect(url_for('index'))
    else:
        return "category add"

@app.route('/items/')
def items():
    categories = CATEGORIES_QUERY
    items = Item.query.all()
    return "items"



from flask import Flask, render_template, request, redirect, jsonify, url_for, flash, make_response
from flask import session as login_session
from flask.ext.seasurf import SeaSurf

#Import content from 'database_model'
from database_model import *

#SQLAlchemy imports to
from sqlalchemy import asc
from sqlalchemy.orm import sessionmaker
#Create new database session using 'engine' defined in 'database_model'
Session = sessionmaker(bind=engine)
session = Session()

import random, string, json, httplib2, requests

from oauth2client.client import flow_from_clientsecrets, FlowExchangeError

app = Flask(__name__)
csrf = SeaSurf(app)

CLIENT_ID = json.loads(
    open('client_secrets.json', 'r').read())['web']['client_id']
APP_NAME = 'Item Catalog Application'

#Create anti-forgery state token
@app.route('/login')
def showLogin():
    state = ''.join(random.choice(string.ascii_uppercase + string.digits)
                    for x in xrange(32))
    login_session['state'] = state
    # return "The current session state is %s" % login_session['state']
    return render_template('login.html', STATE=state)

#Google connect
@csrf.exempt
@app.route('/gconnect', methods=['POST'])
def gconnect():
    # Validate state token
    if request.args.get('state') != login_session['state']:
        response = make_response(json.dumps('Invalid state parameter.'), 401)
        response.headers['Content-Type'] = 'application/json'
        return response
    # Obtain authorization code
    code = request.data

    try:
        # Upgrade the authorization code into a credentials object
        oauth_flow = flow_from_clientsecrets('client_secrets.json', scope='')
        oauth_flow.redirect_uri = 'postmessage'
        credentials = oauth_flow.step2_exchange(code)
    except FlowExchangeError:
        response = make_response(
            json.dumps('Failed to upgrade the authorization code.'), 401)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Check that the access token is valid.
    access_token = credentials.access_token
    url = ('https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=%s'
           % access_token)
    h = httplib2.Http()
    result = json.loads(h.request(url, 'GET')[1])
    # If there was an error in the access token info, abort.
    if result.get('error') is not None:
        response = make_response(json.dumps(result.get('error')), 500)
        response.headers['Content-Type'] = 'application/json'

    # Verify that the access token is used for the intended user.
    gplus_id = credentials.id_token['sub']
    if result['user_id'] != gplus_id:
        response = make_response(
            json.dumps("Token's user ID doesn't match given user ID."), 401)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Verify that the access token is valid for this app.
    if result['issued_to'] != CLIENT_ID:
        response = make_response(
            json.dumps("Token's client ID does not match app's."), 401)
        print "Token's client ID does not match app's."
        response.headers['Content-Type'] = 'application/json'
        return response

    stored_credentials = login_session.get('credentials')
    stored_gplus_id = login_session.get('gplus_id')
    if stored_credentials is not None and gplus_id == stored_gplus_id:
        response = make_response(json.dumps('Current user is already connected.'),
                                 200)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Store the access token in the session for later use.
    login_session['access_token'] = credentials.access_token
    login_session['gplus_id'] = gplus_id

    # Get user info
    userinfo_url = "https://www.googleapis.com/oauth2/v1/userinfo"
    params = {'access_token': credentials.access_token, 'alt': 'json'}
    answer = requests.get(userinfo_url, params=params)

    data = answer.json()

    login_session['provider'] = 'google'
    login_session['username'] = data['name']
    login_session['picture'] = data['picture']
    login_session['email'] = data['email']

    #check to see if user already exists before creating new one
    user_id = getUserID(login_session['email'])
    if not user_id:
        user_id = createUser(login_session)
    login_session['user_id'] = user_id

    output = ''
    output += '<h1>Welcome, '
    output += login_session['username']
    output += '!</h1>'
    output += '<img src="'
    output += login_session['picture']
    output += ' " style = "width: 150px; height: 150px;border-radius: 75px;-webkit-border-radius: 75px;-moz-border-radius: 75px;"> '
    flash("you are now logged in as %s" % login_session['username'])
    print "done!"
    return output

#Pre-disconnect routine for Google connect
@app.route('/gdisconnect')
def gdisconnect():
    # Only disconnect a connected user.
    credentials = login_session.get('credentials')
    if credentials is None:
        response = make_response(
            json.dumps('Current user not connected.'), 401)
        response.headers['Content-Type'] = 'application/json'
        return response
    access_token = credentials.access_token
    url = 'https://accounts.google.com/o/oauth2/revoke?token=%s' % access_token
    h = httplib2.Http()
    result = h.request(url, 'GET')[0]
    if result['status'] != '200':
        #If, for whatever reason, the given token was invalid.
        response = make_response(
            json.dumps('Failed to revoke token for given user.', 400))
        response.headers['Content-Type'] = 'application/json'
        return response

#gconnect() helper functions
def createUser(login_session):
    newUser = User(name=login_session['username'], email=login_session[
                   'email'], picture=login_session['picture'])
    session.add(newUser)
    session.commit()
    user = session.query(User).filter_by(email=login_session['email']).one()
    return user.id

def getUserID(email):
    try:
        user = session.query(User).filter_by(email=email).one()
        return user.id
    except:
        return None

# Disconnect based on provider
@app.route('/disconnect/')
def disconnect():
    if 'provider' in login_session:
        if login_session['provider'] == 'google':
            gdisconnect()
            del login_session['gplus_id']
        del login_session['username']
        del login_session['email']
        del login_session['picture']
        del login_session['user_id']
        del login_session['provider']
        flash("You have successfully been logged out.")
        return redirect(url_for('index'))
    else:
        flash("You were not logged in")
        return redirect(url_for('index'))

#Main page - all item categories
@app.route('/')
@app.route('/index/')
def index():
    categories = session.query(Category).order_by(asc(Category.name))
    items = session.query(Item).order_by(Item.created).limit(4)
    return render_template('index.html',
                            categories = categories,
                            items = items,
                            privacy_status = privacy_check())

@app.route('/categories/')
def categoryGate():
    categories = session.query(Category).order_by(asc(Category.name))
    return render_template('category/categories.html',
                            categories = categories,
                            privacy_status = privacy_check())


#Show a specific Category and associated Items
@app.route('/category/<int:category_id>/')
@app.route('/category/<int:category_id>/home/')
def categoryHome(category_id):
    categories = session.query(Category).order_by(asc(Category.name))
    category = session.query(Category).filter_by(id=category_id).one()
    items = session.query(Item).filter_by(category_id=category_id).all()
    privacy_status = False
    ownership_status = False
    if 'username' in login_session:
        privacy_status = True
        if category.user.id == login_session['user_id']:
            ownership_status = True
    return render_template('category/categoryhome.html',
                            category = category,
                            categories = categories,
                            items = items,
                            privacy_status = privacy_status,
                            ownership_status = ownership_status)


#Create a new Category
@app.route('/category/add/', methods=['GET', 'POST'])
def categoryAdd():
    categories = session.query(Category).order_by(asc(Category.name))
    if 'username' not in login_session:
        return redirect('/login')
    if request.method == 'POST':
        newCategory = Category(name=request.form['name'],
                               description=request.form['description'],
                               photo=request.form['photo'],
                               user_id=login_session['user_id'])
        session.add(newCategory)
        flash('New %s Category Successfully Added' % newCategory.name)
        session.commit()
        return redirect(url_for('index'))
    else:
        return render_template('category/categoryadd.html',
                                categories = categories,
                                privacy_status = privacy_check())

#Edit a Category
@app.route('/category/<int:category_id>/edit/', methods=['GET', 'POST'])
def categoryEdit(category_id):
    categories = session.query(Category).order_by(asc(Category.name))
    if 'username' not in login_session:
        return redirect('/login')
    targetCategory = session.query(Category).filter_by(id=category_id).one()
    if targetCategory.user_id != login_session['user_id']:
        return "<script>function reject() {alert('You do not have permission to edit this Category.');history.go(-1);}</script><body onload='reject()''>"
    if request.method == 'POST':
        if request.form['name']:
            targetCategory.name = request.form['name']
        if request.form['description']:
            targetCategory.description = request.form['description']
        if request.form['photo']:
            targetCategory.photo = request.form['photo']
        flash('Category Information Updated')
        return redirect(url_for('index'))
    else:
        return render_template('category/categoryedit.html',
                               category=targetCategory,
                               privacy_status = privacy_check(),
                               categories = categories)

#Delete a Category
@app.route('/category/<int:category_id>/delete/', methods=['GET', 'POST'])
def categoryDelete(category_id):
    categories = session.query(Category).order_by(asc(Category.name))
    if 'username' not in login_session:
        return redirect('/login')
    targetCategory = session.query(Category).filter_by(id=category_id).one()
    children = session.query(Item).filter_by(category_id=category_id).all()
    if targetCategory.user_id != login_session['user_id']:
        return "<script>function reject() {alert('You do not have permission to delete this Category.');history.go(-1);}</script><body onload='reject()''>"
    if request.method == 'POST':
        session.delete(targetCategory)
        flash('%s Successfully Deleted' % targetCategory.name)
        for i in children:
            session.delete(i)
        session.commit()
        return redirect(url_for('index'))
    else:
        return render_template('category/categorydelete.html',
                               category=targetCategory,
                               privacy_status = privacy_check(),
                               categories = categories)

#MShow all Items
@app.route('/items/')
def itemGate():
    categories = session.query(Category).order_by(asc(Category.name))
    items = session.query(Item).order_by(Item.name)
    return render_template('item/items.html',
                            items = items,
                            privacy_status = privacy_check(),
                            categories = categories)

#Show a specific Item
@app.route('/item/<int:item_id>/')
@app.route('/item/<int:item_id>/home/')
def itemHome(item_id):
    categories = session.query(Category).order_by(asc(Category.name))
    item = session.query(Item).filter_by(id=item_id).one()
    ownership_status = False
    if 'username' in login_session and item.user.id == login_session['user_id']:
        ownership_status = True
    return render_template('item/itemhome.html',
                            item = item,
                            ownership_status = ownership_status,
                            privacy_status = privacy_check(),
                            categories = categories)

#Add a new item
@app.route('/item/add/', methods=['GET', 'POST'])
@app.route('/<int:category_id>/item/add/', methods=['GET', 'POST'])
def itemAdd(category_id):
    categories = session.query(Category).order_by(asc(Category.name))
    if 'username' not in login_session:
        return redirect('/login')
    if request.method == 'POST':
        newItem = Item(name=request.form['name'],
                       description=request.form['description'],
                       photo=request.form['photo'],
                       category_id=request.form['category_id'],
                       user_id=login_session['user_id'])
        session.add(newItem)
        flash('%s Successfully Added' % newItem.name)
        session.commit()
        return redirect(url_for('categoryHome', category_id = newItem.category_id))
    else:
        return render_template('item/itemadd.html',
                                categories = categories,
                                privacy_status = privacy_check(),
                                target = category_id)

#Edit an item
@app.route('/item/<int:item_id>/edit/', methods=['GET', 'POST'])
def itemEdit(item_id):
    if 'username' not in login_session:
        return redirect('/login')
    targetItem = session.query(Item).filter_by(id=item_id).one()
    categories = session.query(Category).order_by(asc(Category.name))
    if targetItem.user_id != login_session['user_id']:
        return "<script>function reject() {alert('You do not have permission to edit this Item.');history.go(-1);}</script><body onload='reject()''>"
    if request.method == 'POST':
        if request.form['category_id']:
            targetItem.category_id = request.form['category_id']
        if request.form['name']:
            targetItem.name = request.form['name']
        if request.form['description']:
            targetItem.description = request.form['description']
        if request.form['photo']:
            targetItem.photo = request.form['photo']
        session.add(targetItem)
        session.commit()
        flash('Item Information Updated')
        return redirect(url_for('itemHome', item_id = item_id))
    else:
        return render_template('item/itemedit.html',
                                item = targetItem,
                                categories = categories,
                                privacy_status = privacy_check())

#Delete an Item
@app.route('/item/<int:item_id>/delete/', methods=['GET', 'POST'])
def itemDelete(item_id):
    categories = session.query(Category).order_by(asc(Category.name))
    if 'username' not in login_session:
        return redirect('/login')
    targetItem = session.query(Item).filter_by(id=item_id).one()
    if targetItem.user_id != login_session['user_id']:
        return "<script>function reject() {alert('You do not have permission to delete this Item.');history.go(-1);}</script><body onload='reject()''>"
    if request.method == 'POST':
        session.delete(targetItem)
        flash('%s Successfully Deleted' % targetItem.name)
        session.commit()
        return redirect(url_for('categoryHome', category_id = targetItem.category_id))
    else:
        return render_template('item/itemdelete.html',
                                item = targetItem,
                                categories = categories,
                                privacy_status = privacy_check())

#JSON endpoints
@app.route('/JSON/')
def aboutJSON():
    categories = session.query(Category).order_by(asc(Category.name))
    return render_template('JSON.html',
                            categories = categories,
                            privacy_status = privacy_check())

@app.route('/categories/JSON/')
def categoriesJSON():
    categories = session.query(Category).order_by(asc(Category.name))
    return jsonify(categories=[c.serialize for c in categories])

@app.route('/items/JSON/')
def itemsJSON():
    items = session.query(Item).order_by(Item.name)
    return jsonify(items=[i.serialize for i in items])

@app.route('/category/<int:category_id>/JSON/')
def categoryJSON(category_id):
    category = session.query(Category).filter_by(id=category_id).one()
    return jsonify(category=category.serialize)

@app.route('/item/<int:item_id>/JSON')
def itemJSON(item_id):
    item = session.query(Item).filter_by(id=item_id).one()
    return jsonify(item = item.serialize)

@app.route('/category/<int:category_id>/items/JSON/')
def categoryItemsJSON(category_id):
    items = session.query(Item).filter_by(category_id=category_id).all()
    return jsonify(items=[i.serialize for i in items])

def privacy_check():
    if 'username' in login_session:
        return True
    return False


if __name__ == '__main__':
    app.secret_key = 'secret_key'
    app.debug = True
    app.run(host = '0.0.0.0', port = 5000)

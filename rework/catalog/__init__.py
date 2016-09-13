from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config.from_pyfile('config.py')

# Flask-SQLAlchemy
db = SQLAlchemy(app)

import catalog.models

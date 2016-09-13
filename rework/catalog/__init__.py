from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Flask-SQLAlchemy
db = SQLAlchemy(app)

import catalog.models

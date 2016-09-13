DEBUG = False
SECRET_KEY = 'lookathowsecretthiskeyis'

# Flask-SQLAlchemy config
db_driver = 'postgresql'
db_user = 'pgdbuser'
db_password = 'pgpassword'
db_host = 'postgres'
db_port = '5432'
db_name = 'itemcatalog'

SQLALCHEMY_DATABASE_URI = '{0}://{1}:{2}@{3}:{4}/{5}'.format(
    db_driver, db_user, db_password, db_host, db_port, db_name
)
SQLALCHEMY_TRACK_MODIFICATIONS = False

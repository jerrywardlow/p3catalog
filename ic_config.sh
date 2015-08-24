apt-get -qqy update
apt-get -qqy install postgresql python-psycopg2
apt-get -qqy install python-flask python-sqlalchemy
apt-get -qqy install python-pip
pip install bleach
pip install oauth2client
pip install requests
pip install httplib2
pip install flask-seasurf

echo "Setting up Postgres Environment"
su postgres -c 'createuser -dRS vagrant'
su vagrant -c 'createdb'
su vagrant -c 'createdb itemcatalog'

echo "Running python database setup"
su vagrant -c 'python /vagrant/database_model.py'
echo "Python database setup complete"

vagrantTip="[36m[1mTo access project files: cd /vagrant[m"
echo -e $vagrantTip > /etc/motd

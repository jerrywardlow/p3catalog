apt-get -qqy update
apt-get -qqy install postgresql python-psycopg2
apt-get -qqy install python-flask python-sqlalchemy
apt-get -qqy install python-pip
pip install oauth2client
pip install requests
pip install httplib2
pip install flask-seasurf
pip install dicttoxml

su postgres -c 'createuser -dRS vagrant'
su vagrant -c 'createdb'
su vagrant -c 'createdb itemcatalog'

su vagrant -c 'python /vagrant/database_model.py'
su vagrant -c 'python /vagrant/populator.py'

vagrantTip="[36m[1mTo access project files: cd /vagrant[m"
echo -e $vagrantTip > /etc/motd

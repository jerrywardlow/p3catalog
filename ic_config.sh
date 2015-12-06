apt-get -qqy update
apt-get -qqy install postgresql python-psycopg2
apt-get -qqy install python-pip
pip install flask
pip install sqlalchemy
pip install oauth2client
pip install requests
pip install httplib2
pip install flask-seasurf
pip install dicttoxml
pip install pyimgur

su postgres -c 'createuser -dRS vagrant'
su vagrant -c 'createdb'
su vagrant -c 'createdb itemcatalog'

su vagrant -c 'python /vagrant/database_model.py'
su vagrant -c 'python /vagrant/populator.py'

echo 'cd /vagrant' > /home/vagrant/.bash_profile

vagrantTip="[36m[1mTo load Item Catalog: 'python itemcatalog.py'[m"
echo -e $vagrantTip > /etc/motd

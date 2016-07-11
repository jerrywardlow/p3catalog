apt-get -qqy update
apt-get -qqy install postgresql python-psycopg2
apt-get -qqy install python-pip

pip install -r /itemcatalog/requirements.txt

su postgres -c 'createuser -dRS vagrant'
su vagrant -c 'createdb'
su vagrant -c 'createdb itemcatalog'

su vagrant -c 'python /itemcatalog/database_model.py'
su vagrant -c 'python /itemcatalog/populator.py'

echo 'cd /itemcatalog' > /home/vagrant/.bash_profile

vagrantTip="[36m[1mTo load Item Catalog: 'python itemcatalog.py'[m"
echo -e $vagrantTip > /etc/motd

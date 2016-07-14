apt-get -qqy update
apt-get -qqy install postgresql python-psycopg2 python-pip

pip install -r /itemcatalog/requirements.txt
pip install gunicorn

su postgres -c 'createuser -dRS vagrant'
su vagrant -c 'createdb'
su vagrant -c 'createdb itemcatalog'

su vagrant -c 'python /itemcatalog/database_model.py'
su vagrant -c 'python /itemcatalog/populator.py'

cp /itemcatalog/itemcatalog.conf /etc/init/
start itemcatalog

echo 'cd /itemcatalog' > /home/vagrant/.bash_profile

vagrantTip="[36m[1mItem Catalog running on 'localhost:5000'[m"
echo -e $vagrantTip > /etc/motd

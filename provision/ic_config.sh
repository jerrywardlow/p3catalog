# Update apt cache
apt-get -qqy update
# Install project packages
apt-get -qqy install python-psycopg2 \
                     python-pip

# Install Python packages
pip install -r /itemcatalog/requirements.txt

# Create new PostgreSQL user and databases
su postgres -c 'createuser -dRS vagrant'
su vagrant -c 'createdb'
su vagrant -c 'createdb itemcatalog'

# Populate databases with catalog model and sample data
su vagrant -c 'python /itemcatalog/database_model.py'
su vagrant -c 'python /itemcatalog/populator.py'

# Copy upstart script and start Gunicorn
cp /itemcatalog/itemcatalog.conf /etc/init/
start itemcatalog

# Automatically change to project directory on login
echo 'cd /itemcatalog' >> /home/vagrant/.bash_profile

# Change the message of the day
vagrantTip="[36m[1mItem Catalog running on 'localhost:5000'[m"
echo -e $vagrantTip > /etc/motd

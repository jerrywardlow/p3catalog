# Update apt cache
apt-get -qqy update
# Install project packages
apt-get -qqy install python-psycopg2 \
                     python-pip

# Install Python packages
pip install -r /itemcatalog/requirements.txt

# Copy upstart script and start Gunicorn
cp /itemcatalog/itemcatalog.conf /etc/init/
start itemcatalog

# Automatically change to project directory on login
echo 'cd /itemcatalog' >> /home/vagrant/.bash_profile

# Change the message of the day
vagrantTip="[36m[1mItem Catalog running on 'localhost:5000'[m"
echo -e $vagrantTip > /etc/motd

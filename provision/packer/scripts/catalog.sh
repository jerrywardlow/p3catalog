# Update apt cache
sudo apt-get -qqy update

# Install packages
sudo apt-get -qqy install python-psycopg2 python-pip git

# Initiate maximum recursion
sudo git clone -n git://github.com/jerrywardlow/p3catalog.git --depth 1
cd /p3catalog
sudo git checkout HEAD app/ && sudo rm -rf .git/

# Install Python dependencies
sudo pip install -r app/requirements.txt

# Modify and reuse Vagrant upstart script
sudo sed -i 's/itemcatalog/p3catalog\/app/' /p3catalog/app/itemcatalog.conf
sudo sed -i 's/vagrant/ubuntu/' /p3catalog/app/itemcatalog.conf
# Copy upstart script and run Gunicorn
sudo cp app/itemcatalog.conf /etc/init/
sudo start itemcatalog

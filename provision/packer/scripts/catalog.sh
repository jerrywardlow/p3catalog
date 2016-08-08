# Update apt cache
sudo apt-get -qqy update

# Install packages
sudo apt-get -qqy install python-psycopg2 python-pip git

# Initiate maximum recursion
sudo git clone -n git://github.com/jerrywardlow/p3catalog.git --depth 1
cd /p3catalog
sudo git checkout HEAD app/

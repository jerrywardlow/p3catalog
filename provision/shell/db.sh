# Update apt cache
apt-get -qqy update
# Install packages
apt-get -qqy install postgresql

# Create new database user and database
su postgres -c "psql -c \"CREATE USER pgdbuser with password 'pgpassword';\""
su postgres -c 'createdb itemcatalog'

# Load sample data into database
su postgres -c 'psql itemcatalog < /db/postgres.sample_catalog.sql'

# Configure PostgreSQL to accept remote connections
echo 'host all all 192.168.56.0/24 password' >> /etc/postgresql/$(ls /etc/postgresql)/main/pg_hba.conf
echo "listen_addresses='*'" >> /etc/postgresql/$(ls /etc/postgresql)/main/postgresql.conf

# Restart the PostgreSQL service
service postgresql restart

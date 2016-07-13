FROM ubuntu:trusty

# Install basic packages needed for the Flask web app
RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                   postgresql \
                   python \
                   python-pip \
                   python-psycopg2

# Add a new user for the web app
RUN useradd flaskapp \
        && adduser flaskapp sudo \
        && sed -i -e \
           's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
           /etc/sudoers

# Install pip packages
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

# Copy all project files to container
COPY . /itemcatalog

WORKDIR /itemcatalog

USER postgres

# Create a new database user
RUN service postgresql start \
        && createuser -dRS flaskapp

USER flaskapp

# Create database for web app and populate it
RUN sudo service postgresql start \
      && createdb itemcatalog \
      && python database_model.py \
      && python populator.py

# Expose port for Flask server
EXPOSE 5000

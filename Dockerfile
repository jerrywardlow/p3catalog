FROM ubuntu:trusty

# Turn off some annoying warnings while installing packages
ENV DEBIAN_FRONTEND noninteractive

# Install basic packages needed for the Flask web app
RUN apt-get update \
        && apt-get install -y --no-install-recommends \
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
COPY app/requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

# Copy all project files to container
COPY app/ /itemcatalog

WORKDIR /itemcatalog

USER flaskapp

# Expose port for Flask server
EXPOSE 5000

CMD gunicorn -b 0.0.0.0:5000 wsgi:app

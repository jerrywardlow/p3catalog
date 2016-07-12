FROM ubuntu:trusty

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                   postgresql \
                   python \
                   python-pip \
                   python-psycopg2

RUN useradd flaskapp

COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

COPY . /itemcatalog

WORKDIR /itemcatalog

USER postgres

RUN service postgresql start \
        && createuser -dRS flaskapp

USER flaskapp

RUN service postgresql start \
        && createdb itemcatalog \
        && python database_model.py \
        && python populator.py

EXPOSE 5000

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

RUN service postgresql start

USER postgres

RUN createuser -dRS flaskapp

USER flaskapp

RUN createdb itemcatalog

RUN python database_model.py \
        && python populator.py

EXPOSE 5000

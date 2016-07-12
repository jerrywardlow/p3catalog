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

RUN service postgresql start

USER postgres

RUN createuser -dRS flaskapp

EXPOSE 5000

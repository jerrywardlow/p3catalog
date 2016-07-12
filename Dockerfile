FROM ubuntu:trusty

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                   postgresql \
                   python \
                   python-pip \
                   python-psycopg2

COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

EXPOSE 5000

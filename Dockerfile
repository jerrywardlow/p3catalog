FROM alpine:latest

# Turn off some annoying warnings while installing packages
ENV DEBIAN_FRONTEND noninteractive

# Install basic packages needed for the Flask web app
RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                   python \
                   python-pip \
                   python-psycopg2

# Copy all project files to container
COPY app/ /itemcatalog

WORKDIR /itemcatalog

# Install pip packages
RUN pip install -r requirements.txt

# Expose port for Flask server
EXPOSE 5000

CMD gunicorn -b 0.0.0.0:5000 wsgi:app

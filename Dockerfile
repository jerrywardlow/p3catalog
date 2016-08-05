FROM alpine:latest

# Install basic packages needed for the Flask web app
RUN apk update \
        && apk add python \
                   py-pip \
                   py-psycopg2

# Copy all project files to container
COPY app/ /itemcatalog

WORKDIR /itemcatalog

# Install pip packages
RUN pip install -r requirements.txt

# Expose port for Flask server
EXPOSE 5000

CMD gunicorn -b 0.0.0.0:5000 wsgi:app

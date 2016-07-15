# Project 3 - Item Catalog
### Udacity - Full Stack - Project 3 - Item Catalog

By Jerry Wardlow for the Udacity [Full Stack Web Developer Nanodegree](https://www.udacity.com/course/full-stack-web-developer-nanodegree--nd004)

### About

This project is a RESTful web application using the Python Flask framework which
accesses a PostgreSQL database to present a catalog which can store information
about items and the categories they belong to. OAuth2 authentication and
authorization is used to allow users access to CRUD (create, read, update and
delete) operations. Users who are logged in to a Google Account can view item
and category information, add new items and categories, and edit and delete
only those items and categories which they have created.

### In This Repository

The project consists of a core Python module (`itemcatalog.py`) which runs the
Flask web application. A PostgreSQL database is created and populated with the
necessary tables during Vagrant provisioning using `database_model.py`. The
Flask web app uses the stored HTML templates in the `templates` folder to
generate the final web pages seen by the user. CSS files and static images are
stored in the `static` folder.

### Using This Project

**Prerequisites**

* The latest version of [Vagrant](https://www.vagrantup.com/downloads.html) for
your preferred platform.
* The files contained in this repository

A detailed list of the Python modules installed during provisioning of our
Vagrant virtual machine can be found in the included `requirements.txt`.

**Running and Testing This Project**

From a command line, change into the `p3catalog` directory of this project. (For
this example, we will assume it is in `/home/user/p3catalog`)

`cd /home/user/p3catalog`

From this directory we will execute our Vagrantfile which will create and
provision the virtual machine required to run this project.

`vagrant up`

Now that the Vagrantfile and corresponding configuration file (`ic_config.sh`)
have finished provisioning our virtual machine, we have an Ubuntu 14.04.3
environment configured to run the Item Catalog project. All necessary packages
have been installed, a PostgreSQL database has been created, configured and
populated (by `populator.py`), and port 5000 (the port used by this project) has
been forwarded correctly. Gunicorn is installed as well to handle our Flask
application.

An Upstart configuration file (`app/itemcatalog.conf`) is copied to our virtual
machine's `/etc/init/` directory allowing Gunicorn to automatically start the
Flask Item Catalog on port 5000. Feel free to run `vagrant ssh` to poke around
in our new server.

Turning our attention to a web browser, we can navigate to
`http://localhost:5000/` and see the web application running correctly. We can
view categories and their associated items and access JSON formatted information
as well. Each requested page is generated dynamically using the Flask
application's Werkzeug WSGI library and Jinja2 templates.

At this point, however, we do not have access to one of the core components of
this project, OAuth.

**Setting Up Google OAuth 2.0 Access**

Though a detailed tutorial for setting up OAuth credentials is outside the scope
of this project, in depth information can be found through [Google Identity
Platform](https://developers.google.com/identity/protocols/OAuth2?hl=en) guides.
After creating a new project through the Google Developers Console, we can
add new 'OAuth 2.0 client ID' credentials. Our application type is a 'Web
application'. 'Authorized JavaScript origins' are `http://localhost:5000` and
'Authorized redirect URIs' are `http://localhost:5000/oauth2callback`. Now we
can download a JSON file of this information, rename it to `client_secrets.json`
and move this file to the root of our project (`/p3catalog/`).

Now that we have updated the Item Catalog project with OAuth 2.0 credentials
from Google, the full functionality of adding, editing, and deleting items and
categories can be used. Items and categories can be created by any logged in
user, and users may edit and delete any objects that they have created.

**Setting Up Imgur API Access**

Image hosting is handled through Imgur using their API. Requests are handled
using the PyImgur library. To use this API, we must register the application
with Imgur's [API Application Registration Page.](https://api.imgur.com/oauth2/addclient)
Setting the Authorization callback URL to localhost:5000 will let us properly
use Imgur's uploads and hosting. Upon successful registration of an application,
we can add the `client_id` key to `website_config.py` under `IMGUR_CLIENT_ID`.

**Cleaning Up**

If we decided to get messy and poke around in the running VM, we can now `exit`
our virtual machine and run `vagrant destroy` to remove all traces of the
Vagrant environment.

### Docker

`docker build -t itemcatalog:latest .`

`docker run -d -p 5000:5000 itemcatalog`

Navigate to `localhost:5000` in your web browser... wow, that's neat! Shouldn't
we peel off the PostgreSQL server into another container, and maybe dump this
all behind NGINX? Wouldn't docker-compose make more sense here? Valid points...

##### Even Less Docker?

Need something with less PostgreSQL and more SQLite? Hate Gunicorn? Looking for
an 81% reduction in image size and an 81% reduction in stability?

`docker run -d -p 5000:5000 jerrywardlow/alpine-catalog`

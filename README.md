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
have been installed, a PostgreSQL database has been created and configured, and
port 5000 (the port used by this project) has been forwarded correctly. We are
now ready to SSH into our virtual machine.

`vagrant ssh`

Now that we are logged into the virtual environment, we can change into the
shared file directory and load our web application.

`cd /vagrant`
`python itemcatalog.py`

This command will start our Flask web application. Turning our attention to a
web browser, we can navigate to `http://localhost:5000/` and see the web
application running correctly. We can view categories and their associated items
and access JSON formatted information as well. Each requested page is generated
dynamically using the Flask application's Werkzeug WSGI library and Jinja2
templates.

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
and move this file to the root of our project (`/p3catalog/`). Finally we must
update line 24 of `login.html` in our `/p3catalog/templates/` directory,
changing `data-clientid="CLIENT_ID"` to your newly generated Client ID.

Now that we have updated the Item Catalog project with OAuth 2.0 credentials
from Google, the full functionality of adding, editing, and deleting items and
categories can be used. Items and categories can be created by any logged in
user, and users may edit and delete any objects that they have created.

**Cleaning Up**

The web application can be terminated from the command line with `ctrl+c`. We
can now `exit` our virtual machine and run `vagrant destroy` to remove all
traces of the Vagrant environment.
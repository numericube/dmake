# dmake

Dmake is a frontend to Docker+Swarm, providing sensible defaults for usual CI/CD tasks such as:

* keeping track of various environments (dev/test/prod/etc)

* managing releases and deployments

* performing day-to-day operations on a Swarm cluster (eg "I want to run this piece of code on that environment")

* ...and do all of this with AWS or Azure clusters!

We are making a few assumptions for now:

* We use Docker (obviously)

* We use docker-compose because it's the right tool for this job.

* We use Swarm. We know this is a controversial choice but we plan to move the whole project to Kubernetes. In the meantime... ...sorry: Swarm.

* We assume your repository is hosted on Git 🤷‍

* Your provision configuration is stored in the 'provision/' directory by default (customizable)


# General principles

dmake makes your development, releases and deployment operations WAY simpler and streamlined with Docker+Swarm.

It practically makes your project fool-proof for users who don't know or do not want to learn all about Docker.

But it allows power users to save time and energy by providing convenient frontends to most operations.

The only thing you have to do is describe your project architecture in the 'provision/' directory.
And we provided a few tools to get you started right away.


# Getting started: a dmake tutorial

Suppose you want to build an architecture with 3 different Ubuntu containers.
The first thing is to get them running with Docker, as you'd do with your usual containers anyway.

Then we provide a few shortcuts to convert this machines into your docker-compose files. The rest is copy/paste. Easy.

For example, let's create a project and run 3 containers that just wait forever::

  $ mkdir sandbox # Or you can start from an existing git repository
  $ cd sandbox
  $ docker run --name my_container1 ubuntu sleep infinity &
  $ docker run --name my_container1 ubuntu sleep infinity &
  $ docker run --name my_container1 ubuntu sleep infinity &

You've got an Ubuntu container running and waiting forever. Let's integrate it into our project.

  $ dmake init

We've now created a 'provision' directory with all the necessary files to have your architecture up and ready.


Then, from your project's root::

  dmake

  dmake -h

  dmake status -h   # From an in-depth review of how your files should be layed out.

# FAQ

# Testing dmake

Use a virtualenv, pretty please. The rest is pretty easy:

$ pip install -e .
$ pip install pytest
$ python -m pytest [--skipslow]

# Releasing dmake

For release operations, we use a stripped-down version of dmake release (eat your own dog food) and a Travis
configuration. So, to perform a release:

* **Make sure you are in branch master**. Other branches are not supported.

* dmake release

* Grab a (long) coffee, your dmake installation will be available at https://numericube.blob.core.windows.net/dmake-public/dmake-generic-py3-none-any.whl after extensive testing on Travis.

# Upgrading dmake

That's easy:

$ dmake upgrade

# dmake
A "docker-make" in Python, used to help work on our projects.

# Getting started
This project must be included from other projects. Several ways to do so.

* Make sure you have read access to NumeriCube's git dmake repository

* Use the following commands (possibly with sudo):

   $ pip install https://numericube.blob.core.windows.net/dmake-public/dmake-generic-py3-none-any.whl   # For released version
   $ pip install git+https://pjgrizel@github.com/numericube/dmake.git	                                 # For development version

   Make sure your Python installation is 3.6+. You may have to use the following command instead:

   $ pip3 install https://numericube.blob.core.windows.net/dmake-public/dmake-generic-py3-none-any.whl   # For released version
   $ pip3 install git+https://pjgrizel@github.com/numericube/dmake.git	                                 # For development version

* [OPTIONAL] Install Azure and AWS clients if necessary:

   $ pip[3] install azure


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

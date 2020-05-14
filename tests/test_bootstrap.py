#!/usr/bin/env python
# encoding: utf-8
"""
bootstrap_test.py

Created by Pierre-Julien Grizel et al.
Copyright (c) 2016 NumeriCube. All rights reserved.

Tests bootstrap files
"""
from __future__ import unicode_literals

import contextlib
import os
import tempfile

import dmake

from .fixtures import dmake_module

__author__ = ""
__copyright__ = "Copyright 2016, NumeriCube"
__credits__ = ["Pierre-Julien Grizel"]
__license__ = "CLOSED SOURCE"
__version__ = "TBD"
__maintainer__ = "Pierre-Julien Grizel"
__email__ = "pjgrizel@numericube.com"
__status__ = "Production"


def test_import():
    """Test basic imports"""
    import dmake
    from dmake import aws, common, bootstrap, deploy


def test_bootstrap(dmake_module):
    """Test creation of a bootstrap dir"""
    # Basic file creation
    with open("README.md", "w") as readme:
        readme.write("Sample project dir")

    # Create repo and first commit
    os.system("git init")
    os.system("git add README.md")
    os.system("git commit -m First")

    # Bootstrap it
    assert not os.system("dmake bootstrap -w test")

    # Now we test content :)
    assert os.path.isfile("provision/docker-compose.yml")

#!/usr/bin/env python
# encoding: utf-8
"""
test_basic.py

Created by Pierre-Julien Grizel et al.
Copyright (c) 2016 NumeriCube. All rights reserved.

Test if dmake is just callable
"""
from __future__ import unicode_literals

import os

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


def test_basic():
    """Test if I can call dmake"""
    # dmake will fail as no command is provided
    assert os.system("dmake") == 512
    assert not os.system("dmake --help")


def test_branch(dmake_module):
    """Test branching and check if variables are okay"""
    os.system("git checkout -b mybranch")
    print("DONE.")
    # make("-v", "status")


def test_branch2(dmake_module):
    """Test branching and check if variables are okay.
    Test a second time so that we make sure ENVIRON and caches will not spoil the thing."""
    os.system("git checkout -b mybranch")
    # make("-v", "status")

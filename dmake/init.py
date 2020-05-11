#!/usr/bin/env python
# encoding: utf-8
"""
init.py

Created by Pierre-Julien Grizel et al.
Copyright (c) 2019 NumeriCube. All rights reserved.

Simple init of dmake-made projects
"""
# Python3 rocks :)
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import argparse
import os
import re
import shutil
import textwrap

from . import base_commands
from .common import HERE
from .common import bcolors
from .common import printc

# pylint: disable=E0401
__author__ = ""
__copyright__ = "Copyright 2016, NumeriCube"
__credits__ = ["Pierre-Julien Grizel"]
__license__ = "CLOSED SOURCE"
__version__ = "TBD"
__maintainer__ = "Pierre-Julien Grizel"
__email__ = "pjgrizel@numericube.com"
__status__ = "Production"


# ########################################################################## #
# ####                      BOOTSTRAP NEW PROJECT                       #### #
# ########################################################################## #


class Init(base_commands.BaseCommand):
    """Bootstrap a new project. Pass along complimentary options to create a project
    with specific settings. Files are only [OVER]written with the --write option.
    """

    project_name = None

    arguments = (
        {
            "name": ("project_name",),
            "help": "Name of the project. Normally it's mandatory but may be guessed if some files are already there.",
            "action": "store",
            "nargs": "?",
        },
        {
            "name": ("--dry-run",),
            "help": "Write the generated config files. If not set, files will be printed.",
            "action": "store_false",
            "dest": "write",
        },
    )

    def read_and_convert(self, f_source):
        """Read a source template file and convert variable arguments
        """
        # Sanity check
        if not self.project_name:
            raise ValueError(
                "PROJECT_NAME is not set. Pass it as an argument if necessary."
            )

        # List of regexps to replace
        regexps = ((r"myproject", self.project_name),)

        # Open, read, replace
        content = f_source.read()
        for regexp, sub in regexps:
            content = re.sub(regexp, sub, content)
        return content

    def cmdrun(self,):
        """Perform bootstrapping.
        """
        # Basic directories
        # target_dir = self.get_provision_dir()
        target_dir = self.get_provision_dir(os.path.abspath(os.path.curdir))
        template_dir = os.path.join(HERE, "templates")

        # Guess project name if not given
        if not self.project_name:
            self.project_name = os.environ.get("PROJECT_NAME")
            if not self.project_name:
                self.project_name = os.path.split(os.path.abspath(os.path.curdir))[-1]

        # We may have to create target_dir
        if self.write and not os.path.isdir(target_dir):
            os.mkdir(target_dir)

        # Now let's dig into template_dir and add what matters.
        for filename in os.listdir(template_dir):
            # Skip files not ending with 'tpl'
            if not filename.endswith(".tpl"):
                continue

            # Put each file in its proper place
            source = os.path.join(template_dir, filename)
            target = os.path.join(target_dir, filename[:-4])
            if self.write and os.path.isfile(target):
                printc(bcolors.WARNING, "Skipping {}".format(target))
                continue
            with open(source, "r") as f_source:
                content = self.read_and_convert(f_source)
                if self.write:
                    printc(bcolors.INFO, "Writing  {}".format(target))
                    with open(target, "w") as f_target:
                        f_target.write(content)
                else:
                    printc(bcolors.INFO, target)
                    printc(bcolors.INFO, "=" * len(target))
                    print(content)

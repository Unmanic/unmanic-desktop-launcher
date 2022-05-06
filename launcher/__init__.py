#!/usr/bin/env python3
# -*- coding:utf-8 -*-
###
# File: launcher.py
# Project: unmanic-launcher
# File Created: Sunday, 13th March 2022 8:25:09 pm
# Author: Josh Sunnex (jsunnex@gmail.com)
# -----
# Last Modified: Thursday, 5th May 2022 10:27:52 pm
# Modified By: Josh.5 (jsunnex@gmail.com)
###
# python3 -c "import launcher; launcher.main()"

from .tray import UnmanicLauncher


def main():
    launcher = UnmanicLauncher()
    launcher.run()

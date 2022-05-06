#!/usr/bin/env python3
# -*- coding:utf-8 -*-
###
# File: launcher.py
# Project: unmanic-launcher
# File Created: Sunday, 13th March 2022 8:25:09 pm
# Author: Josh Sunnex (jsunnex@gmail.com)
# -----
# Last Modified: Thursday, 28th April 2022 3:22:58 pm
# Modified By: Josh.5 (jsunnex@gmail.com)
###
# python3 -m launcher
import argparse
from .tray import UnmanicLauncher

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('--updater', action='store_true')
    args = parser.parse_args()
    if args.updater:
        from .updater import show_window
        show_window()
    else:
        launcher = UnmanicLauncher()
        launcher.run()

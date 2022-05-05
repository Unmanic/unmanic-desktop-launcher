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
import os
import psutil
import subprocess

from pystray import MenuItem as item
import pystray
from PIL import Image

from . import common

os.environ['PATH'] += ';' + common.ffmpeg_path


class UnmanicLauncher:

    def __init__(self):
        self.unmanic_service = None
        self.icon = None
        self.unmanic_proc = None

    @staticmethod
    def __terminate_proc_tree(proc: psutil.Process):
        """
        Terminate the process tree (including grandchildren).
        Processes that fail to stop with SIGTERM will be sent a SIGKILL.

        :param proc:
        :return:
        """
        children = proc.children(recursive=True)
        children.append(proc)
        for p in children:
            try:
                p.terminate()
            except psutil.NoSuchProcess:
                pass
        gone, alive = psutil.wait_procs(children, timeout=3)
        for p in alive:
            try:
                p.kill()
            except psutil.NoSuchProcess:
                pass
        psutil.wait_procs(alive, timeout=3)

    def update_unmanic(self):
        # TODO: Make this also cleaned up on shutdown
        update_command = [common.python_exe, '-m', 'launcher', '--updater']
        proc, sp = common.exec_process(update_command)

    def start_unmanic(self):
        try:
            # Ensure the module is installed
            import unmanic
            # Run Unmanic as a subprocess
            subprocess_command = [common.python_exe, '-m', 'unmanic']
            self.unmanic_proc, sp = common.exec_process(subprocess_command)
        except ModuleNotFoundError:
            # Unmanic is not yet installed
            # Install it...
            self.update_unmanic()

    def stop_unmanic(self):
        # Terminate Unmanic
        if self.unmanic_proc is not None and self.unmanic_proc.is_running():
            self.__terminate_proc_tree(self.unmanic_proc)

    def action_exit(self):
        self.icon.visible = False
        self.icon.stop()

    def create_icon(self):
        # When installed, the icon will be up a level
        image = None
        if os.path.exists(os.path.join(common.module_root, 'assets', 'icon.ico')):
            # When running from this script
            image = Image.open(os.path.join(common.module_root, 'assets', 'icon.ico'))
        self.icon = pystray.Icon("Unmanic", image, "Unmanic", (item('Exit', self.action_exit),))

    def run(self):
        # Create icon
        self.create_icon()
        # Start Unmanic
        self.start_unmanic()
        # Create tray icon
        self.icon.run()
        # Stop Unmanic
        self.stop_unmanic()


def main():
    launcher = UnmanicLauncher()
    launcher.run()

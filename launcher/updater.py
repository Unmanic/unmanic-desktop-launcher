import os
import sys
import threading

from PyQt5 import QtWidgets

from .update_window import Ui_MainWindow
from . import common


class Window(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)

        self.ui.add_button.clicked.connect(self.exec_update)

    def get_radio_option(self):
        if self.ui.radio_1.isChecked():
            return 'stable'
        elif self.ui.radio_2.isChecked():
            return 'beta'
        return None

    def exec_update(self):
        channel = self.get_radio_option()
        self.ui.listWidget.clear()
        if channel is None:
            QtWidgets.QListWidgetItem('Select an update channel!', self.ui.listWidget)
            return
        elif channel == 'beta':
            QtWidgets.QListWidgetItem('Checking for updates from the beta channel...', self.ui.listWidget)
            pip_install_command = [common.python_exe, '-m', 'pip', 'install', '--pre', '--upgrade', '--no-cache-dir',
                                   '--no-binary=unmanic', 'git+https://github.com/Unmanic/unmanic.git@staging']
        else:
            QtWidgets.QListWidgetItem('Checking for updates from the stable channel...', self.ui.listWidget)
            pip_install_command = [common.python_exe, '-m', 'pip', 'install', '--upgrade', 'unmanic']
        thread = threading.Thread(target=self.exec_threaded_subprocess, args=(pip_install_command,))
        thread.start()

    def exec_threaded_subprocess(self, pip_install_command):
        # Disable button
        self.ui.add_button.setEnabled(False)
        # Exec subprocess
        proc, sp = common.exec_process(pip_install_command)
        while True:
            # Read lines
            text = sp.stdout.readline()
            # Append line to log (stripping out trailing whitespace)
            QtWidgets.QListWidgetItem(text.rstrip(), self.ui.listWidget)
            # Check if the command has completed. If it has, exit the loop
            if text == '' and sp.poll() is not None:
                break
        # Re-enable button
        self.ui.add_button.setEnabled(True)


def show_window():
    app = QtWidgets.QApplication(sys.argv)
    window = Window()
    window.show()
    sys.exit(app.exec_())

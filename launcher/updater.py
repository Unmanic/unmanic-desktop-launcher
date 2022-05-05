import sys
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
        if channel is None:
            QtWidgets.QListWidgetItem('Select an update channel!', self.ui.listWidget)
            return
        elif channel == 'beta':
            QtWidgets.QListWidgetItem('Checking for updates from the beta channel...', self.ui.listWidget)
            pip_install_command = [common.python_exe, '-m', 'pip', 'install', '--pre', '--upgrade', 'unmanic']
        else:
            QtWidgets.QListWidgetItem('Checking for updates from the stable channel...', self.ui.listWidget)
            pip_install_command = [common.python_exe, '-m', 'pip', 'install', '--upgrade', 'unmanic']
        # Exec pip install
        proc, sp = common.exec_process(pip_install_command)
        text = ' '.join(sp.stdout.readlines())
        QtWidgets.QListWidgetItem(text, self.ui.listWidget)


def show_window():
    app = QtWidgets.QApplication(sys.argv)
    window = Window()
    window.show()
    sys.exit(app.exec_())

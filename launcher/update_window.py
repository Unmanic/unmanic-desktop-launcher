# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'main.ui'
#
# Created by: PyQt5 UI code generator 5.5.1
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(893, 606)

        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.centralwidget)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.groupBox = QtWidgets.QGroupBox(self.centralwidget)
        self.groupBox.setObjectName("groupBox")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.groupBox)
        self.verticalLayout.setObjectName("verticalLayout")

        self.radio_1 = QtWidgets.QRadioButton(self.groupBox)
        self.radio_1.setObjectName("radio_1")
        self.verticalLayout.addWidget(self.radio_1)
        self.radio_2 = QtWidgets.QRadioButton(self.groupBox)
        self.radio_2.setObjectName("radio_2")
        self.verticalLayout.addWidget(self.radio_2)
        self.add_button = QtWidgets.QPushButton(self.groupBox)
        self.add_button.setObjectName("add_button")
        self.verticalLayout.addWidget(self.add_button)
        spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.verticalLayout.addItem(spacerItem)
        self.horizontalLayout.addWidget(self.groupBox)

        self.listWidget = QtWidgets.QListWidget(self.centralwidget)
        self.listWidget.setObjectName("listWidget")
        self.horizontalLayout.addWidget(self.listWidget)
        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "UpdateWindow"))

        self.groupBox.setTitle(_translate("MainWindow", "Select an update channel"))
        self.radio_1.setText(_translate("MainWindow", "Stable"))
        self.radio_2.setText(_translate("MainWindow", "Beta"))

        self.add_button.setText(_translate("MainWindow", "Download/Install Updates"))

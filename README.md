# Unmanic launcher for Windows

## Features
- Display a tray icon in your task bar

## Install

### Windows
Download the [latest release](https://github.com/Unmanic/unmanic-desktop-launcher/releases)

Run the executable

## Build

### Setup build environment

#### Install Python 3.12
From the [windows store](https://www.microsoft.com/p/python-37/9nj46sx7x90p)
Or installation via another means.

#### Install nsis v3
https://nsis.sourceforge.io/Download

#### Install other tools with powershell script
```
scripts\install-tools.ps1
```

### Build project
To build the project, run:
```
scripts\build.ps1
```

## Develop
Start by running through the build steps listed above
To create a development environment for this, run:
```
scripts\dev.ps1
```

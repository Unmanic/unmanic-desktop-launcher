#!/bin/bash

script_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
project_path=$(realpath ${script_path}/..)

# CONFIG

# Ensure the dependencies directory exists
if [[ ! -d ${project_path}/build/dependencies ]]; then
    mkdir -p ${project_path}/build/dependencies
    echo "Dependencies directory created successfully"
fi

# Create venv
echo "Setup Python build environment"
pushd "${project_path}" &>/dev/null || exit
# Ensure venv exists
if [[ ! -d "${project_path}/venv" ]]; then
    python3 -m venv venv
fi
# Activate the venv
source ./venv/bin/activate
# Install Unmanic Launcher Python dependencies
python3 -m pip install --upgrade -r requirements.txt -r requirements-dev.txt
popd &>/dev/null || exit

# Create wheels for all Unmanic Launcher dependencies
echo "Create wheels for all Unmanic Launcher dependencies"
pushd "${project_path}" &>/dev/null || exit
if [[ -d "${project_path}/build/dependencies/wheels" ]]; then
    rm -rfv "${project_path}/build/dependencies/wheels"
fi
python3 -m pip wheel --wheel-dir build/dependencies/wheels -r requirements.txt
popd &>/dev/null || exit

# Set project version
echo "Set project version"
pushd "${project_path}" &>/dev/null || exit
sem_ver=$(build/tools/gitversion/gitversion /showvariable SemVer)
echo "${sem_ver}" >launcher/version.txt
popd &>/dev/null || exit

# Prepare project
echo "Prepare project"
pushd "${project_path}" &>/dev/null || exit
# Clone build environment
rm -rf build/appimage
cp -rf config/appimage build/
# Add main project dependencies to requirements
cat requirements.txt >>build/appimage/requirements.txt
# Create a wheel from the launcher
python3 -m pip wheel --no-verify -w ${project_path}/build/dependencies/wheels .
# Add wheel to requirements
echo "${project_path}/build/dependencies/wheels/$(ls -a build/dependencies/wheels | grep launcher)" >>build/appimage/requirements.txt
popd &>/dev/null || exit

# Pack project
echo "Pack project v${sem_ver}"
pushd "${project_path}/build" &>/dev/null || exit
python3 -m python_appimage build app -p 3.8 appimage/
popd &>/dev/null || exit

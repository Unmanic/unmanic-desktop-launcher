#!/bin/bash

script_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
project_path=$(realpath "${script_path}/..")

# CONFIG
gitversion_version="5.10.1"
gitversion_url="https://github.com/GitTools/GitVersion/releases/download/${gitversion_version}/gitversion-linux-x64-${gitversion_version}.tar.gz"

# Ensure the tools directory exists
if [[ ! -d ${project_path}/build/tools ]]; then
    mkdir -p "${project_path}/build/tools"
    echo "Tools directory created successfully"
fi

# Fetch GitVersion
echo "Fetch GitVersion"
pushd "${project_path}" &>/dev/null || exit
if [[ ! -f "build/tools/gitversion-${gitversion_version}.tar.gz" ]]; then
    mkdir -p "build/tools"
    curl -L "${gitversion_url}" --output "build/tools/gitversion-${gitversion_version}.tar.gz"
    if [[ -f "build/tools/gitversion/gitversion" ]]; then
        rm -f "build/tools/gitversion/gitversion"
    fi
fi
if [[ ! -f "build/tools/gitversion/gitversion" ]]; then
    mkdir -p "${project_path}/build/tools/gitversion"
    tar xvf "${project_path}/build/tools/gitversion-${gitversion_version}.tar.gz" --directory="${project_path}/build/tools/gitversion"
    chmod +x "${project_path}/build/tools/gitversion/gitversion"
fi
popd &>/dev/null || exit

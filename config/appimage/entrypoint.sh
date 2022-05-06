#! /bin/bash -i
export PYSTRAY_BACKEND=${PYSTRAY_BACKEND:-appindicator}
if [[ "$@" == '--shell' ]]; then
    {{ python-executable }}
else
    {{ python-executable }} -m launcher "$@"
fi

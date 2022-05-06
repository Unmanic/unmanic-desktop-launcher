import os
import shutil
import subprocess

import psutil

module_root = os.path.abspath(os.path.dirname(os.path.realpath(__file__)))
project_root = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..'))
python_exe = os.environ['_']
if os.name == "nt":
    python_exe = os.path.join(project_root, 'Python', 'python.exe')
ffmpeg_path = 'ffmpeg'
if os.name == "nt":
    ffmpeg_path = os.path.join(project_root, 'ffmpeg')


def exec_process(subprocess_command: list):
    """
    Start a subprocess and return the psutil Process object

    :param subprocess_command:
    :return:
    """
    subprocess_kwargs = {}
    if os.name == "nt":
        # For Windows, prevent the subprocess opening its own terminal
        si = subprocess.STARTUPINFO()
        # si.dwFlags = subprocess.STARTF_USESTDHANDLES | subprocess.STARTF_USESHOWWINDOW
        si.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        subprocess_kwargs = {
            'shell':       True,
            'startupinfo': si,
        }
        # creation_flags= subprocess.CREATE_NO_WINDOW
    unmanic_process = subprocess.Popen(subprocess_command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                       universal_newlines=True, errors='replace',
                                       **subprocess_kwargs)
    # Fetch process using psutil for control (sending SIGSTOP on Windows will not work)
    return psutil.Process(pid=unmanic_process.pid), unmanic_process

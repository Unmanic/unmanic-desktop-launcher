#!python3.7
import subprocess
import sys, os
import site

import psutil

scriptdir, script = os.path.split(os.path.abspath(__file__))
installdir = scriptdir  # for compatibility with commands
pkgdir = os.path.join(scriptdir, 'pkgs')
sys.path.insert(0, pkgdir)
# Ensure .pth files in pkgdir are handled properly
site.addsitedir(pkgdir)
py_site_packages = os.path.join(scriptdir, 'Python', 'Lib', 'site-packages')
os.environ['PYTHONPATH'] = pkgdir + os.pathsep + os.environ.get('PYTHONPATH', '')
os.environ['PYTHONPATH'] = py_site_packages + os.pathsep + os.environ.get('PYTHONPATH', '')

# APPDATA should always be set, but in case it isn't, try user home
# If none of APPDATA, HOME, USERPROFILE or HOMEPATH are set, this will fail.
appdata = os.environ.get('APPDATA', None) or os.path.expanduser('~')

if 'pythonw' in sys.executable:
    # Running with no console - send all stdstream output to a file.
    kw = {'errors': 'replace'} if (sys.version_info[0] >= 3) else {}
    sys.stdout = sys.stderr = open(os.path.join(appdata, script + '.log'), 'w', **kw)
else:
    # In a console. But if the console was started just for this program, it
    # will close as soon as we exit, so write the traceback to a file as well.
    def excepthook(etype, value, tb):
        "Write unhandled exceptions to a file and to stderr."
        import traceback
        traceback.print_exception(etype, value, tb)
        with open(os.path.join(appdata, script + '.log'), 'w') as f:
            traceback.print_exception(etype, value, tb, file=f)


    sys.excepthook = excepthook

# Add any included deps paths here
python_exe = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Python', 'python.exe'))
ffmpeg_path = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'ffmpeg'))
os.environ['PATH'] += ';' + ffmpeg_path


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

    def start_unmanic(self):
        # Run Unmanic as a subprocess
        subprocess_command = [python_exe, '-m', 'unmanic']
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
        self.unmanic_proc = psutil.Process(pid=unmanic_process.pid)

    def stop_unmanic(self):
        # Terminate Unmanic
        if self.unmanic_proc.is_running():
            self.__terminate_proc_tree(self.unmanic_proc)

    def run(self):
        # Start Unmanic
        self.start_unmanic()


def main():
    launcher = UnmanicLauncher()
    launcher.run()


# if __name__ == '__main__':
#    main()


def start_unmanic():
    # TODO: Ensure that it is not already running
    # TODO: Ensure that unmanic is installed
    # Run Unmanic as a subprocess
    subprocess_command = [python_exe, '-m', 'unmanic']
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
    subprocess.Popen(subprocess_command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                     universal_newlines=True, errors='replace',
                     **subprocess_kwargs)


def stop_unmanic():
    pass


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('command', type=str, help='(start|stop|restart|update)')
    # parser.add_argument('--sum', dest='accumulate', action='store_const',
    #                    const=sum, default=max,
    #                    help='sum the integers (default: find the max)')

    args = parser.parse_args()
    if args.command == 'start':
        start_unmanic()
    elif args.command == 'stop':
        stop_unmanic()

import os
import setuptools

launcher_directory = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'launcher')
with open(os.path.join(launcher_directory, 'version.txt')) as version_file:
    version = version_file.read().strip()

with open("README.md", "r", encoding="utf8") as fh:
    long_description = fh.read()


def requirements():
    with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'requirements.txt'))) as f:
        return f.read().splitlines()


setuptools.setup(
    name="launcher",
    version=version,
    description="Unmanic Launcher",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/Unmanic/unmanic-launcher/",
    project_urls={
        "Documentation": "https://docs.unmanic.app/",
        "Code":          "https://github.com/Unmanic/unmanic-launcher/",
        "Issue tracker": "https://github.com/Unmanic/unmanic-launcher/issues",
    },
    python_requires='>=3.11',
    install_requires=requirements(),
    platforms='Unix-like',
    package_data={'launcher': ['*.py', 'version.txt']},
    packages=['launcher'],
    classifiers=[
        "Programming Language :: Python :: 3",
        "Programming Language :: Unix Shell",
        "Topic :: System :: Shells",
        "Topic :: System :: System Shells",
        "Topic :: Terminals",
        "Topic :: System :: Networking",
        "License :: OSI Approved :: BSD License"
    ],
    license="GPLv3",
    author="Josh.5",
    author_email="jsunnex@gmail.com"
)

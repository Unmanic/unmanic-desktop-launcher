$projectPath = (get-item $PSScriptRoot ).parent.FullName

# CONFIG
$ffmpegVersion = "6.0.1-8"
$ffmpegUrl = "https://repo.jellyfin.org/files/ffmpeg/windows/latest-6.x/win64/jellyfin-ffmpeg_6.0.1-8-portable_win64.zip"
$nodeVersion = "20.19.4"
$nodeUrl = "https://nodejs.org/dist/v$nodeVersion/node-v$nodeVersion-win-x64.zip"
$gitVersion = "2.36.1"
$gitUrl = "https://github.com/git-for-windows/git/releases/download/v$gitVersion.windows.1/MinGit-$gitVersion-64-bit.zip"

# Ensure the dependencies directory exists
if (!(Test-Path "$projectPath\build\dependencies")) {
    New-Item $projectPath\build\dependencies -ItemType Directory
    Write-Host "Dependencies directory created successfully"
}

# Create venv
Write-Output "Setup Python build environment"
Set-Location -Path $projectPath
# Ensure venv exists
if (!(Test-Path "$projectPath\venv")) {
    python -m venv venv
}
# Activate the venv
.\venv\Scripts\Activate.ps1
# Install Unmanic Launcher Python dependencies
python -m pip install --upgrade -r requirements.txt -r requirements-dev.txt


# Create wheels for all Unmanic Launcher dependencies
Write-Output "Create wheels for all Unmanic Launcher dependencies"
Set-Location -Path $projectPath
if (Test-Path "$projectPath\build\dependencies\wheels") {
    Remove-Item -Recurse -Force "$projectPath\build\dependencies\wheels"
}
python -m pip wheel --wheel-dir build\dependencies\wheels -r requirements.txt


# Fetch GIT
Write-Output "Fetch GIT"
Set-Location -Path $projectPath
if (!(Test-Path "build\dependencies\MinGit-$gitVersion-64-bit.zip")) {
    Invoke-WebRequest -Uri $gitUrl -OutFile build\dependencies\MinGit-$gitVersion-64-bit.zip
    if (Test-Path "$projectPath\build\dependencies\git\cmd\git.exe") {
        Remove-Item -Path "$projectPath\build\dependencies\git\cmd\git.exe"
    }
}
if (!(Test-Path "$projectPath\build\dependencies\git\cmd\git.exe")) {
    if (Test-Path "$projectPath\build\dependencies\git") {
        Remove-Item -Recurse -Force "$projectPath\build\dependencies\git"
    }
    Expand-Archive -LiteralPath $projectPath\build\dependencies\MinGit-$gitVersion-64-bit.zip -DestinationPath $projectPath\build\dependencies\git
}


# Fetch NodeJS
Write-Output "Fetch NodeJS"
Set-Location -Path $projectPath
if (!(Test-Path "build\dependencies\node-v$nodeVersion-win-x64.zip")) {
    Invoke-WebRequest -Uri $nodeUrl -OutFile build\dependencies\node-v$nodeVersion-win-x64.zip
    if (Test-Path "$projectPath\build\dependencies\node\node.exe") {
        Remove-Item -Path "$projectPath\build\dependencies\node\node.exe"
    }
}
if (!(Test-Path "$projectPath\build\dependencies\node\node.exe")) {
    if (Test-Path "$projectPath\build\dependencies\node-v$nodeVersion-win-x64") {
        Remove-Item -Recurse -Force "$projectPath\build\dependencies\node-v$nodeVersion-win-x64"
    }
    Expand-Archive -LiteralPath $projectPath\build\dependencies\node-v$nodeVersion-win-x64.zip -DestinationPath $projectPath\build\dependencies
    if (Test-Path "$projectPath\build\dependencies\node") {
        Remove-Item -Recurse -Force "$projectPath\build\dependencies\node"
    }
    Rename-Item $projectPath\build\dependencies\node-v$nodeVersion-win-x64 $projectPath\build\dependencies\node
}


# Fetch FFmpeg
Write-Output "Fetch FFmpeg"
Set-Location -Path $projectPath
if (!(Test-Path "build\dependencies\jellyfin-ffmpeg-$ffmpegVersion.zip")) {
    Invoke-WebRequest -Uri $ffmpegUrl -OutFile build\dependencies\jellyfin-ffmpeg-$ffmpegVersion.zip
    if (Test-Path "$projectPath\build\dependencies\ffmpeg\ffmpeg.exe") {
        Remove-Item -Path "$projectPath\build\dependencies\ffmpeg\ffmpeg.exe"
    }
}
if (!(Test-Path "$projectPath\build\dependencies\ffmpeg\ffmpeg.exe")) {
    if (Test-Path "$projectPath\build\dependencies\ffmpeg") {
        Remove-Item -Recurse -Force "$projectPath\build\dependencies\ffmpeg"
    }
    Expand-Archive -LiteralPath $projectPath\build\dependencies\jellyfin-ffmpeg-$ffmpegVersion.zip -DestinationPath $projectPath\build\dependencies\ffmpeg
}


# Set project version
Write-Output "Set project version"
Set-Location -Path $projectPath
$semVer = build\tools\gitversion\gitversion.exe /showvariable SemVer
(Get-Content config\windows\installer.cfg ) -Replace 'version=0.0.1', "version=$semVer" | Set-Content installer.configured.cfg


# Pack project
Write-Output "Pack project v$semVer"
Set-Location -Path $projectPath
python -m nsist installer.configured.cfg --no-makensis

# Print next steps
$makensisPath = (python -c "import nsist; print(nsist.find_makensis_win())") -join "`n"
Write-Output "Project built. To package the project, run:"
Write-Output "      & '$makensisPath' .\build\nsis\installer.nsi"

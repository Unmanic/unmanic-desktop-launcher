$projectPath = (get-item $PSScriptRoot ).parent.FullName

# CONFIG
$ffmpegVersion = "4.4.1-3"
$ffmpegUrl = "https://repo.jellyfin.org/releases/server/windows/versions/jellyfin-ffmpeg/4.4.1-3/jellyfin-ffmpeg_4.4.1-3-windows_win64.zip"

# Ensure the dependencies directory exists
if (!(Test-Path "build\dependencies")) {
    New-Item build\dependencies -ItemType Directory
    Write-Host "Tools directory created successfully"
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
python -m pip install --upgrade -r requirements.txt


# Create wheels for all Unmanic Launcher dependencies
Write-Output "Create wheels for all Unmanic Launcher dependencies"
Set-Location -Path $projectPath
if (Test-Path "$projectPath\build\dependencies\wheels") {
    Remove-Item -Recurse -Force "$projectPath\build\dependencies\wheels"
}
python -m pip wheel --wheel-dir build\dependencies\wheels -r requirements.txt


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
(Get-Content installer.cfg) -Replace 'version=0.0.1', "version=$semVer" | Set-Content installer.configured.cfg

# Pack project
Write-Output "Pack project v$semVer"
Set-Location -Path $projectPath
python -m nsist installer.configured.cfg

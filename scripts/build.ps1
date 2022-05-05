$projectPath = (get-item $PSScriptRoot ).parent.FullName

# CONFIG
$ffmpegVersion = "4.4.1-3"
$ffmpegUrl = "https://repo.jellyfin.org/releases/server/windows/versions/jellyfin-ffmpeg/4.4.1-3/jellyfin-ffmpeg_4.4.1-3-windows_win64.zip"


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
if (Test-Path "$projectPath\build\dependencies") {
    Remove-Item -Recurse -Force "$projectPath\build\dependencies"
}
python -m pip wheel --wheel-dir build\dependencies -r requirements.txt


# Fetch FFmpeg
Write-Output "Fetch FFmpeg"
Set-Location -Path $projectPath
if (!(Test-Path "build\jellyfin-ffmpeg-$ffmpegVersion.zip")) {
    Invoke-WebRequest -Uri $ffmpegUrl -OutFile build\jellyfin-ffmpeg-$ffmpegVersion.zip
    if (Test-Path "$projectPath\build\ffmpeg\ffmpeg.exe") {
        Remove-Item -Path "$projectPath\build\ffmpeg\ffmpeg.exe"
    }
}
if (!(Test-Path "$projectPath\build\ffmpeg\ffmpeg.exe")) {
    if (Test-Path "$projectPath\build\ffmpeg") {
        Remove-Item -Recurse -Force "$projectPath\build\ffmpeg"
    }
    Expand-Archive -LiteralPath $projectPath\build\jellyfin-ffmpeg-$ffmpegVersion.zip -DestinationPath $projectPath\build\ffmpeg
}

# Pack project
Write-Output "Pack project"
Set-Location -Path $projectPath
python -m nsist installer.cfg --no-makensis

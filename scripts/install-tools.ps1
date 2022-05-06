$projectPath = (get-item $PSScriptRoot ).parent.FullName

# CONFIG
$gitVersionVersion = "5.10.1"
$gitVersionUrl = "https://github.com/GitTools/GitVersion/releases/download/$gitVersionVersion/gitversion-win-x64-$gitVersionVersion.zip"

# Ensure the tools directory exists
if (!(Test-Path "build\tools")) {
    New-Item build\tools -ItemType Directory
    Write-Host "Tools directory created successfully"
}

# Fetch GitVersion
Write-Output "Fetch GitVersion"
Set-Location -Path $projectPath
if (!(Test-Path "build\tools\gitversion-$gitVersionVersion.zip")) {
    Invoke-WebRequest -Uri $gitVersionUrl -OutFile build\tools\gitversion-$gitVersionVersion.zip
    if (Test-Path "$projectPath\build\tools\gitversion\gitversion.exe") {
        Remove-Item -Path "$projectPath\build\tools\gitversion\gitversion.exe"
    }
}
if (!(Test-Path "$projectPath\build\tools\gitversion\gitversion.exe")) {
    if (Test-Path "$projectPath\build\tools\gitversion") {
        Remove-Item -Recurse -Force "$projectPath\build\tools\gitversion"
    }
    Expand-Archive -LiteralPath $projectPath\build\tools\gitversion-$gitVersionVersion.zip -DestinationPath $projectPath\build\tools\gitversion
}

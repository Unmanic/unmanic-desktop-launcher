$projectPath = (get-item $PSScriptRoot ).parent.FullName

# CONFIG
$gitVersionVersion = "5.10.1"
$gitVersionUrl = "https://github.com/GitTools/GitVersion/releases/download/$gitVersionVersion/gitversion-win-x64-$gitVersionVersion.zip"

# Fetch GitVersion
Write-Output "Fetch GitVersion"
Set-Location -Path $projectPath
if (!(Test-Path "build\gitversion-$gitVersionVersion.zip")) {
    Invoke-WebRequest -Uri $gitVersionUrl -OutFile build\gitversion-$gitVersionVersion.zip
    if (Test-Path "$projectPath\build\gitversion\gitversion.exe") {
        Remove-Item -Path "$projectPath\build\gitversion\gitversion.exe"
    }
}
if (!(Test-Path "$projectPath\build\gitversion\gitversion.exe")) {
    if (Test-Path "$projectPath\build\gitversion") {
        Remove-Item -Recurse -Force "$projectPath\build\gitversion"
    }
    Expand-Archive -LiteralPath $projectPath\build\gitversion-$gitVersionVersion.zip -DestinationPath $projectPath\build\gitversion
}

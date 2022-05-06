$projectPath = (get-item $PSScriptRoot ).parent.FullName

Set-Location -Path $

Write-Output "Remove launcher from build"
if (Test-Path "$projectPath\build\nsis\pkgs\launcher") {
    Remove-Item -Recurse -Force "$projectPath\build\nsis\pkgs\launcher"
}
New-Item -ItemType Junction -Path "$projectPath\build\nsis\pkgs\launcher" -Target "$projectPath\launcher"

Write-Output "run launcher"
build\nsis\Python\python.exe -m launcher

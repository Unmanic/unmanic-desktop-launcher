$projectPath = (get-item $PSScriptRoot ).parent.FullName

Set-Location -Path $projectPath
if (Test-Path "$projectPath\build\nsis\pkgs\launcher") {
    Write-Output "Remove launcher from build"
    Remove-Item -Recurse -Force "$projectPath\build\nsis\pkgs\launcher"
}
Write-Output "Re-install launcher from current source"
Copy-Item -Path "$projectPath\launcher" -Destination "$projectPath\build\nsis\pkgs\launcher" -Recurse

Write-Output "Run launcher"
build\nsis\Python\python.exe -m launcher

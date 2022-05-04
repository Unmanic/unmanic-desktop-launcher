$projectPath = (get-item $PSScriptRoot ).parent.FullName

# CONFIG
$autoitUrl = "https://www.autoitscript.com/cgi-bin/getfile.pl?autoit3/autoit-v3.zip"

# Install build tools
Write-Output "Fetch AutoIT compiler dependencies"
Set-Location -Path $projectPath
if (!(Test-Path "build\autoit-v3.zip")) {
    Invoke-WebRequest -Uri $autoitUrl -OutFile build\autoit-v3.zip
    if (Test-Path "$projectPath\build\autoit\install\Aut2Exe\Aut2exe_x64.exe") {
        Remove-Item -Path "$projectPath\build\autoit\install\Aut2Exe\Aut2exe_x64.exe"
    }
}
if (!(Test-Path "$projectPath\build\autoit\install\Aut2Exe\Aut2exe_x64.exe")) {
    if (Test-Path "$projectPath\build\autoit") {
        Remove-Item -Recurse -Force "$projectPath\build\autoit"
    }
    Expand-Archive -LiteralPath $projectPath\build\autoit-v3.zip -DestinationPath $projectPath\build\autoit
}

Clear-Host;
Write-Host;
Write-Host "=========================================";
Write-Host "=         Zabbix Agent Deployer         =";
Write-Host "=========================================";
Write-Host "= Developed -by Ezequiel Lage (@ezlage) =";
Write-Host "= Sponsored -by Lageteck (lageteck.com) =";
Write-Host "=========================================";
Write-Host;

# === Changing the default behavior on error ===
$OldEAP = $ErrorActionPreference;
$ErrorActionPreference = 'Stop';

# === Changing to the script directory ===
$CurPath = Split-Path -Parent $PSCommandPath;
Set-Location $CurPath;

# === Starting the work ===
Write-Host "Updating dependencies...";
Write-Host;

# === Downloading, extracting and copying the PSExec tool ===  
Write-Host "Sysinternals' PsExec: " -NoNewline;
Try {
    Invoke-WebRequest "https://download.sysinternals.com/files/PSTools.zip" -OutFile "$env:TEMP\PSTools.zip";
    Expand-Archive -Path "$env:TEMP\PSTools.zip" -DestinationPath "$env:TEMP\PSTools" -Force;
    Copy-Item -Path "$env:TEMP\PSTools\PsExec.exe" -Destination "bin\psexec.exe" -Force;
    Copy-Item -Path "$env:TEMP\PSTools\Eula.txt" -Destination "bin\psexec-license.txt" -Force;
    Remove-Item -Path "$env:TEMP\PSTools" -Recurse -Force;
    Remove-Item -Path "$env:TEMP\PSTools.zip" -Force;
    Write-Host "OK!" -ForegroundColor Green;
} Catch {
    Write-Host "FAILED!" -ForegroundColor Red;
}

# === Downloading, extracting and copying the Uninstall tool ===  
Write-Host "Tarma's Uninstall: " -NoNewline;
Try {
    Invoke-WebRequest "https://tarma.com/download/Uninstall.zip" -OutFile "$env:TEMP\Uninstall.zip";
    Expand-Archive -Path "$env:TEMP\Uninstall.zip" -DestinationPath "$env:TEMP\Uninstall" -Force;
    Copy-Item -Path "$env:TEMP\Uninstall\UninstallX86.exe" -Destination "bin\uninstall.exe" -Force;
    Remove-Item -Path "$env:TEMP\Uninstall" -Recurse -Force;
    Remove-Item -Path "$env:TEMP\Uninstall.zip" -Force;
    Write-Host "OK!" -ForegroundColor Green;
} Catch {
    Write-Host "FAILED!" -ForegroundColor Red;
}

# === Downloading, extracting and copying the 7-Zip tool ===  
Write-Host "Igor Pavlov's 7-Zip: " -NoNewline;
Try {
    $WebReq = Invoke-WebRequest "https://www.7-zip.org/download.html";
    $Lines = $WebReq.Content -split "`"";
    ForEach ($Line in $Lines) {
      If ($Line -like "*-extra.7z*") {
        Invoke-WebRequest "https://www.7-zip.org/$Line" -OutFile "$env:TEMP\7zip-extra.7z";        
        Break;
      }
    }    
    Start-Process -FilePath ".\bin\7za.exe" -ArgumentList "x `"$env:TEMP\7zip-extra.7z`" -bd -y -o`"$env:TEMP\7zip-extra`"" -WindowStyle Hidden -Wait;    
    Copy-Item -Path "$env:TEMP\7zip-extra\7za.exe" -Destination "bin\7za.exe" -Force;
    Copy-Item -Path "$env:TEMP\7zip-extra\7za.dll" -Destination "bin\7za.dll" -Force;
    Copy-Item -Path "$env:TEMP\7zip-extra\7zxa.dll" -Destination "bin\7zxa.dll" -Force;
    Copy-Item -Path "$env:TEMP\7zip-extra\License.txt" -Destination "bin\7za-license.txt" -Force;
    Remove-Item -Path "$env:TEMP\7zip-extra" -Recurse -Force;
    Remove-Item -Path "$env:TEMP\7zip-extra.7z" -Force;
    Write-Host "OK!" -ForegroundColor Green;
} Catch {
    Write-Host "FAILED!" -ForegroundColor Red;
}

# === Downloading, extracting and copying the cURL tool ===  
Write-Host "cURL: " -NoNewline;
Try {
    Invoke-WebRequest "https://curl.se/windows/curl-win32-latest.zip" -OutFile "$env:TEMP\curl-win32-latest.zip";
    Start-Process -FilePath ".\bin\7za.exe" -ArgumentList "e `"$env:TEMP\curl-win32-latest.zip`" -bd -y -o`"$env:TEMP\curl-win32-latest`"" -WindowStyle Hidden -Wait;    
    Copy-Item -Path "$env:TEMP\curl-win32-latest\curl.exe" -Destination "bin\curl.exe" -Force;
    Copy-Item -Path "$env:TEMP\curl-win32-latest\libcurl.dll" -Destination "bin\libcurl.dll" -Force;
    Copy-Item -Path "$env:TEMP\curl-win32-latest\curl-ca-bundle.crt" -Destination "bin\curl-ca-bundle.crt" -Force;
    Get-Content -Path "$env:TEMP\curl-win32-latest\COPYING*.txt" | Set-Content -Force -Path "bin\curl-license.txt"    
    Remove-Item -Path "$env:TEMP\curl-win32-latest" -Recurse -Force;
    Remove-Item -Path "$env:TEMP\curl-win32-latest.zip" -Force;
    Write-Host "OK!" -ForegroundColor Green;
} Catch {
    Write-Host "FAILED!" -ForegroundColor Red;
}

# === Issuing the last notice ===
Write-Host;
Write-Host "----------------------------------> Done.";
Write-Host;

# === Restoring the default behavior on error ===
$ErrorActionPreference = $OldEAP;
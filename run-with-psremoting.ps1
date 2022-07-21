Clear-Host;
Write-Host;
Write-Host "=========================================";
Write-Host "=         Zabbix Agent Deployer         =";
Write-Host "=========================================";
Write-Host "= Developed -by Ezequiel Lage (@ezlage) =";
Write-Host "= Sponsored -by Lageteck (lageteck.com) =";
Write-Host "=========================================";
Write-Host;

# === Changing the default action on error ===
$OldEAP = $ErrorActionPreference;
$ErrorActionPreference = 'Stop';

# === Changing to the script directory ===
$CurPath = Split-Path -Parent $PSCommandPath;
Set-Location $CurPath;

# === Starting the work ===
Write-Host "Deploying the Zabbix Agent...";
Write-Host;
[string[]] $Servers = Get-Content -Path 'cfg\servers.txt';
ForEach ($Server in $Servers) {    
  $Server = $Server.Trim();
  If (![string]::IsNullOrEmpty($Server)) {
    Try {    
      Copy-Item -Path "pkg\zabbixagent32.msi" -Destination "\\$($Server)\C$\Windows\Temp" -Force;
      Copy-Item -Path "pkg\zabbixagent64.msi" -Destination "\\$($Server)\C$\Windows\Temp" -Force;
      Copy-Item -Path "bin\uninstall.exe" -Destination "\\$($Server)\C$\Windows\Temp" -Force;
      Copy-Item -Path "cfg\callback.bat" -Destination "\\$($Server)\C$\Windows\Temp\zad-callback.bat" -Force;
      Invoke-Command -ComputerName $Server -AsJob -ScriptBlock {      
        Start-Process -FilePath zad-callback.bat -WorkingDirectory "C:\Windows\Temp" -Wait -ErrorAction Continue;      
      } | Out-Null;
      Write-Host $Server -ForegroundColor Green;    
    } Catch {
      Write-Host $Server -ForegroundColor Red;
    }
  }
}

# === Issuing the last notice ===
Write-Host;
Write-Host "Background jobs have been started! Keep this window open and use the 'Get-Job' and 'Receive-Job' commands to track the progress." -ForegroundColor Yellow;

# === Restoring the default action on error ===
$ErrorActionPreference = $OldEAP;
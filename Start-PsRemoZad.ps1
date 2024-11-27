Clear-Host;

Write-Host;
Write-Host "=========================================";
Write-Host "=         Zabbix Agent Deployer         =";
Write-Host "=========================================";
Write-Host "= Developed -by Ezequiel Lage (@ezlage) =";
Write-Host "= Sponsored -by Lageteck (lageteck.com) =";
Write-Host "= Material protected by a license (MIT) =";
Write-Host "=========================================";
Write-Host;

# Changing the default action on error, warning or progress
$EPref = $ErrorActionPreference;
$WPref = $WarningPreference;
$PPref = $ProgressPreference;
$ErrorActionPreference = 'Stop';
$WarningPreference = 'SilentlyContinue';
$ProgressPreference = 'SilentlyContinue';

# Changing current location
$CDR = Get-Location;
Set-Location (Split-Path -Parent $PSCommandPath);

# Issuing notice and starting the work
Write-Host "Deploying the Zabbix Agent...";
Write-Host;
[string[]] $Servers = Get-Content -Path 'cfg\servers.txt';
foreach ($Server in $Servers) {    
    $Server = $Server.Trim();
    if (![string]::IsNullOrEmpty($Server)) {
        try {    
            Copy-Item -Path "pkg\zabbixagent32.msi" -Destination "\\$($Server)\C$\Windows\Temp" -Force;
            Copy-Item -Path "pkg\zabbixagent64.msi" -Destination "\\$($Server)\C$\Windows\Temp" -Force;
            Copy-Item -Path "bin\uninstall.exe" -Destination "\\$($Server)\C$\Windows\Temp" -Force;
            Copy-Item -Path "cfg\callback.bat" -Destination "\\$($Server)\C$\Windows\Temp\zad-callback.bat" -Force;
            Invoke-Command -ComputerName $Server -AsJob -ScriptBlock {      
            Start-Process -FilePath zad-callback.bat -WorkingDirectory "C:\Windows\Temp" -Wait -ErrorAction Continue;      
            } | Out-Null;
            Write-Host $Server -ForegroundColor Green;    
        } catch {
            Write-Host $Server -ForegroundColor Red;
        }
    }
}

# Restoring location
Set-Location $CDR;

# Restoring default behavior on error
$ErrorActionPreference = $EPref;
$WarningPreference = $WPref;
$ProgressPreference = $PPref;

# Cleaning up
Clear-Variable CDR;
Clear-Variable EPref;
Clear-Variable WPref;
Clear-Variable PPref;
Clear-Variable Servers;
Clear-Variable Server;

# Issuing the last notice
Write-Host;
Write-Host "Background jobs have been started! Keep this window open and use the 'Get-Job' and 'Receive-Job' commands to track the progress." -ForegroundColor Yellow;

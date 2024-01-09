@ECHO OFF & CLS

REM Environment-specific parameters
REM SET "AGENTNAME=Zabbix Agent"
SET "AGENTNAME=Zabbix Agent 2"
SET "SERVER=127.0.0.1"
SET "SERVERACTIVE=127.0.0.1"
SET "LISTENPORT=10050"
SET "ENABLEPATH=1"
SET "CONTROLLOG=C:\Windows\Temp\zad-control.log"
SET "UNINSTALLLOG=C:\Windows\Temp\zad-uninstall.log"
SET "INSTALLLOG=C:\Windows\Temp\zad-install.log"

ECHO. > "%CONTROLLOG%"
ECHO ========================================= >> "%CONTROLLOG%"
ECHO =         Zabbix Agent Deployer         = >> "%CONTROLLOG%"
ECHO ========================================= >> "%CONTROLLOG%"
ECHO = Developed -by Ezequiel Lage (@ezlage) = >> "%CONTROLLOG%"
ECHO = Sponsored -by Lageteck (lageteck.com) = >> "%CONTROLLOG%"
ECHO = Material protected by a license (MIT) = >> "%CONTROLLOG%"
ECHO ========================================= >> "%CONTROLLOG%"
ECHO. >> "%CONTROLLOG%"
ECHO START: %DATE% %TIME% >> "%CONTROLLOG%"

REM Uninstalling previous versions
ECHO PHASE 1: %DATE% %TIME% >> "%CONTROLLOG%"
"C:\Windows\System32\net.exe" STOP "%AGENTNAME%" 2>&1 >> "%CONTROLLOG%"
FOR /F "USEBACKQ TOKENS=1 DELIMS=:" %%I IN (`C:\Windows\Temp\uninstall.exe ^| FIND /I /V "%AGENTNAME% 2" ^| FIND /I "%AGENTNAME%"`) DO (C:\Windows\System32\msiexec.exe /L*V "%UNINSTALLLOG%" /X %%I /QN /NORESTART)
RD /S /Q "%INSTALLFOLDER%" 2>&1 >> "%CONTROLLOG%"

REM Detecting the current architecture
ECHO PHASE 2: %DATE% %TIME% >> "%CONTROLLOG%"
SET "ARCH=NOARCH"
"C:\Windows\System32\systeminfo.exe" | FIND /I "x64-based" >> "%CONTROLLOG%" && SET "ARCH=64"
"C:\Windows\System32\systeminfo.exe" | FIND /I "x86-based" >> "%CONTROLLOG%" && SET "ARCH=32"
IF %ARCH% EQU NOARCH GOTO END

REM Installing the appropriate package
ECHO PHASE 3: %DATE% %TIME% >> "%CONTROLLOG%"
SET "INSTALLFOLDER=%PROGRAMFILES%\%AGENTNAME%"
"C:\Windows\System32\msiexec.exe" /L*V "%INSTALLLOG%" /I "C:\Windows\Temp\zabbixagent%ARCH%.msi" /QN /NORESTART^
    SERVER=%SERVER%^
    LISTENPORT=%LISTENPORT%^
    SERVERACTIVE=%SERVERACTIVE%^
    ENABLEPATH=%ENABLEPATH%^
    INSTALLFOLDER="%INSTALLFOLDER%"
NET START "%AGENTNAME%" 2>&1 >> "%CONTROLLOG%"

:END
REM Cleaning up
ECHO PHASE 4: %DATE% %TIME% >> "%CONTROLLOG%"
SET "AGENTNAME="
SET "INSTALLFOLDER="
SET "SERVER="
SET "SERVERACTIVE="
SET "LISTENPORT="
SET "ENABLEPATH="
SET "ARCH="
SET "I="
SET "INSTALLLOG="
SET "UNINSTALLLOG="
IF EXIST "C:\Windows\Temp\uninstall.exe" DEL "C:\Windows\Temp\uninstall.exe" 2>&1 >> "%CONTROLLOG%"
IF EXIST "C:\Windows\Temp\zabbixagent32.msi" DEL "C:\Windows\Temp\zabbixagent32.msi" 2>&1 >> "%CONTROLLOG%"
IF EXIST "C:\Windows\Temp\zabbixagent64.msi" DEL "C:\Windows\Temp\zabbixagent64.msi" 2>&1 >> "%CONTROLLOG%"
START /MIN "" "C:\Windows\System32\cmd.exe" /C ""C:\Windows\System32\timeout.exe" /T 5 2>NUL 1>NUL & DEL "C:\Windows\Temp\zad-callback.bat" & ECHO END: %DATE% %TIME% >> "%CONTROLLOG%""
SET "CONTROLLOG="
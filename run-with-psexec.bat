@ECHO OFF
CLS
SETLOCAL ENABLEDELAYEDEXPANSION

ECHO.
ECHO =========================================
ECHO =         Zabbix Agent Deployer         =
ECHO =========================================
ECHO = Developed -by Ezequiel Lage (@ezlage) =
ECHO = Sponsored -by Lageteck (lageteck.com) =
ECHO =========================================
ECHO.

REM === Changing to the script directory ===
SET "HERE=%~DP0"
CD /D "%HERE:~0,-1%"

REM === Starting the work ===
ECHO Deploying the Zabbix Agent...
ECHO.
FOR /F "USEBACKQ TOKENS=*" %%I IN ("cfg\servers.txt") DO (
  SET "STATUS=OK"
  ECHO | SET /P="%%I: "
  COPY /Y "pkg\zabbixagent32.msi" "\\%%I\C$\Windows\Temp" 2>NUL 1>NUL || SET "STATUS=ERROR"
  COPY /Y "pkg\zabbixagent64.msi" "\\%%I\C$\Windows\Temp" 2>NUL 1>NUL || SET "STATUS=ERROR"
  COPY /Y "bin\uninstall.exe" "\\%%I\C$\Windows\Temp" 2>NUL 1>NUL || SET "STATUS=ERROR"
  COPY /Y "cfg\callback.bat" "\\%%I\C$\Windows\Temp\zad-callback.bat" 2>NUL 1>NUL || SET "STATUS=ERROR"
  "bin\psexec.exe" -ACCEPTEULA /S /H \\%%I "C:\Windows\System32\cmd.exe" /C "C:\Windows\Temp\zad-callback.bat" 2>NUL 1>NUL || SET "STATUS=ERROR"
  TYPE "\\%%I\C$\Windows\Temp\zad-install.log" | FIND /I "Product: Zabbix Agent" | FIND /I "Installation completed successfully" 2>NUL 1>NUL || SET "STATUS=ERROR"
  ECHO !STATUS!^^!
)

ECHO.
ECHO ----------------------------------^> Done.
ECHO.
@ECHO OFF & CLS
SETLOCAL ENABLEDELAYEDEXPANSION

ECHO.
ECHO =========================================
ECHO =         Zabbix Agent Deployer         =
ECHO =========================================
ECHO = Developed -by Ezequiel Lage (@ezlage) =
ECHO = Sponsored -by Lageteck (lageteck.com) =
ECHO = Material protected by a license (MIT) =
ECHO =========================================
ECHO.

REM Changing current location
FOR /F "DELIMS=" %%I IN ('CD') DO SET "CDR=%%I"
SET "HERE=%~DP0"
CD /D "%HERE:~0,-1%"

REM Checking dependencies
IF EXIST "bin\psexec.exe" GOTO START
ECHO Dependency "bin\psexec.exe" missing.
ECHO Please run "Update-ZadDeps.bat" first^^!
GOTO END

:START

REM Issuing notice and starting the work
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

:END

REM Restoring location
CD /D "%CDR%"

REM Cleaning up
SET "I="
SET "CDR="
SET "HERE="
SET "STATUS="

REM Issuing the last notice
ECHO.
ECHO ----------------------------------^> Done.
ECHO.
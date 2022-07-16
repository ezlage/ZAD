@ECHO OFF
CLS
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
ECHO Updating dependencies...
ECHO.

REM === Downloading and updating dependencies ===
CALL :PSEXEC
CALL :UNINSTALL
CALL :7ZIP
CALL :CURL
GOTO END

:PSEXEC
REM === Downloading, extracting and copying the PSExec tool ===
ECHO | SET /P="Sysinternals' PsExec: "
"bin\curl.exe" -s "https://download.sysinternals.com/files/PSTools.zip" --output "%TEMP%\PSTools.zip" 2>NUL 1>NUL
"bin\7za.exe" e "%TEMP%\PSTools.zip" -bd -y -o"%TEMP%\PSTools" 2>NUL 1>NUL
COPY /Y "%TEMP%\PSTools\PsExec.exe" "bin\psexec.exe" 2>NUL 1>NUL
COPY /Y "%TEMP%\PSTools\Eula.txt" "bin\psexec-license.txt" 2>NUL 1>NUL
DEL /F /Q "%TEMP%\PSTools.zip" 2>NUL 1>NUL
RD /S /Q "%TEMP%\PSTools" 2>NUL 1>NUL
IF EXIST "bin\psexec.exe" (ECHO OK!) ELSE (ECHO FAILED!)
GOTO :EOF

:UNINSTALL
REM === Downloading, extracting and copying the Uninstall tool ===
ECHO | SET /P="Tarma's Uninstall: "
"bin\curl.exe" -s "https://tarma.com/download/Uninstall.zip" --output "%TEMP%\Uninstall.zip" 2>NUL 1>NUL
"bin\7za.exe" e "%TEMP%\Uninstall.zip" -bd -y -o"%TEMP%\Uninstall" 2>NUL 1>NUL
COPY /Y "%TEMP%\Uninstall\UninstallX86.exe" "bin\uninstall.exe" 2>NUL 1>NUL
DEL /F /Q "%TEMP%\Uninstall.zip" 2>NUL 1>NUL
RD /S /Q "%TEMP%\Uninstall" 2>NUL 1>NUL
IF EXIST "bin\uninstall.exe" (ECHO OK!) ELSE (ECHO FAILED!)
GOTO :EOF

:7ZIP
REM === Downloading, extracting and copying the 7-Zip tool ===
ECHO | SET /P="Igor Pavlov's 7-Zip: "
"bin\curl.exe" -s "https://www.7-zip.org/download.html" --output "%TEMP%\7zip-downloadpage.tmp" 2>NUL 1>NUL
TYPE "%TEMP%\7zip-downloadpage.tmp" | FIND /I "-extra.7z" > "%TEMP%\7zip-relevantlines.tmp"
FOR /F "USEBACKQ TOKENS=*" %%A IN ("%TEMP%\7zip-relevantlines.tmp") DO (
    ECHO %%A > "%TEMP%\7zip-link.tmp"
    FOR /F USEBACKQ^ TOKENS^=6^ DELIMS^=^" %%B IN ("%TEMP%\7zip-link.tmp") DO (
        "bin\curl.exe" -s "https://www.7-zip.org/%%B" --output "%TEMP%\7zip-extra.7z" 2>NUL 1>NUL
        GOTO OUT
    )        
)
:OUT
"bin\7za.exe" x "%TEMP%\7zip-extra.7z" -bd -y -o"%TEMP%\7zip-extra" 2>NUL 1>NUL
COPY /Y "%TEMP%\7zip-extra\7za.dll" "bin\7za.dll" 2>NUL 1>NUL
COPY /Y "%TEMP%\7zip-extra\7za.exe" "bin\7za.exe" 2>NUL 1>NUL
COPY /Y "%TEMP%\7zip-extra\7zxa.dll" "bin\7zxa.dll" 2>NUL 1>NUL
COPY /Y "%TEMP%\7zip-extra\License.txt" "bin\7za-license.txt" 2>NUL 1>NUL
DEL /F /Q "%TEMP%\7zip-extra.7z" 2>NUL 1>NUL
DEL /F /Q "%TEMP%\7zip-*.tmp" 2>NUL 1>NUL
RD /S /Q "%TEMP%\7zip-extra" 2>NUL 1>NUL
IF EXIST "bin\7za.exe" (
    IF EXIST "bin\7za.dll" (
            IF EXIST "bin\7zxa.dll" (ECHO OK!) ELSE (ECHO FAILED!)
        ) ELSE (ECHO FAILED!)
) ELSE (ECHO FAILED!)
GOTO :EOF

:CURL
REM === Downloading, extracting and copying the cURL tool ===
ECHO | SET /P="cURL: "
"bin\curl.exe" -s "https://curl.se/windows/curl-win32-latest.zip" --output "%TEMP%\curl-win32-latest.zip" 2>NUL 1>NUL
"bin\7za.exe" e "%TEMP%\curl-win32-latest.zip" -bd -y -o"%TEMP%\curl-win32-latest" 2>NUL 1>NUL
COPY /Y "%TEMP%\curl-win32-latest\curl.exe" "bin\curl.exe" 2>NUL 1>NUL
COPY /Y "%TEMP%\curl-win32-latest\libcurl.dll" "bin\libcurl.dll" 2>NUL 1>NUL
COPY /Y "%TEMP%\curl-win32-latest\curl-ca-bundle.crt" "bin\curl-ca-bundle.crt" 2>NUL 1>NUL
COPY "%TEMP%\curl-win32-latest\COPYING*.txt" "bin\curl-license.txt" /Y 2>NUL 1>NUL
DEL /F /Q "%TEMP%\curl-win32-latest.zip" 2>NUL 1>NUL
RD /S /Q "%TEMP%\curl-win32-latest" 2>NUL 1>NUL
IF EXIST "bin\curl.exe" (
    IF EXIST "bin\libcurl.dll" (
            IF EXIST "bin\curl-ca-bundle.crt" (ECHO OK!) ELSE (ECHO FAILED!)
        ) ELSE (ECHO FAILED!)
) ELSE (ECHO FAILED!)
GOTO :EOF

:END
REM === Issuing the last notice ===
ECHO.
ECHO ----------------------------------^> Done.
ECHO.
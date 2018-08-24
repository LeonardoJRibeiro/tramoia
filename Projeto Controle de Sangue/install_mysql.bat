
@echo off

echo.
set password=root
set installer="C:\Program Files (x86)\MySQL\MySQL Installer for Windows\MySQLInstallerConsole.exe"
echo Instalando...
echo.

msiexec /i "%~dp0\mysql.msi" /qb
msiexec /i "%~dp0\server.msi" /qb
%installer% community configure server:port=3306;passwd=%password% -silent

pause
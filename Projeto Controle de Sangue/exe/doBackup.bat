@ECHO OFF
FOR /F "tokens=1,2,3 delims=/ " %%a in ("%DATE%") do (
set DIA=%%a
set MES=%%b
set ANO=%%c
)
set data=%DIA%_%MES%_%ANO%
mysqldump.exe -B -c --single-transaction --default-character-set=latin1 banco -u root --password="root" -h localhost > "%~dp0Backup\backup_%data%.sql"
forfiles.exe -p"%~dp0Backup" -m*.sql -c"cmd /c del /f /q @FILE" -d-180


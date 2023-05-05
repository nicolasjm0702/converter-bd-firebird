@echo off
if %1 == "" goto ajuda

if not exist "%1" (
   echo error!
   echo Arquivo %1 não encontrado.
   goto fim
)

set ISC_USER=SYSDBA
if exist "*.log" (
   del *.log
)
echo.
echo Convertendo arquivo %1
echo Isso pode levar alguns minutos.

set ext=%1
set ext=%ext:~-4%

set file="ods11%ext%"
powershell mv "%1" "%file%"
fb25\gbak -z -b -g -t -v -st t -y backup_25.log %file% stdout|^
fb30\gbak -z -c -v -st t -y restore_30.log stdin %1

IF %ERRORLEVEL% NEQ 0 (
   del %1
   powershell mv "%file%" "%1"
   echo.
   echo Algo deu errado!
   echo Verifique os arquivos de log.
   goto fim
)

del "%file%"

echo.
echo Arquivo convertido com sucesso!
exit /B 0

:ajuda
echo .
echo converter.cmd <nome do arquivo>
echo .
exit /B 1

:fim
EXIT /B %ERRORLEVEL%
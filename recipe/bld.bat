cd src\windows\Installer.Windows\
if errorlevel 1 exit /b %errorlevel%

powershell -Command ".\layout.ps1 -Configuration WindowsRelease -Output payload -SymbolOutput symbols"
if errorlevel 1 exit /b %errorlevel%

cd payload
if errorlevel 1 exit /b %errorlevel%

rem Already exists in the package
del NOTICE
if errorlevel 1 exit /b %errorlevel%

move * %LIBRARY_BIN%

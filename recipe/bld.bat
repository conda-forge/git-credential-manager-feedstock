cd build\windows\
if errorlevel 1 exit /b %errorlevel%

powershell -Command ".\publish.ps1 -Configuration release -Output payload -SymbolOutput symbols -Aot $true"
if errorlevel 1 exit /b %errorlevel%

cd payload
if errorlevel 1 exit /b %errorlevel%

rem Already exists in the package
del NOTICE
if errorlevel 1 exit /b %errorlevel%

move * %LIBRARY_BIN%

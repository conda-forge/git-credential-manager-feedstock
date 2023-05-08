dotnet tool install git-credential-manager ^
  --tool-path %DOTNET_TOOLS% ^
  --add-source %SRC_DIR% ^
  --verbosity diagnostic
if errorlevel neq 0 exit /b %errorlevel%

cd %PREFIX%\dotnet\tools\.store\%PKG_NAME%\%PKG_VERSION%\%PKG_NAME%\%PKG_VERSION%\tools\net6.0\any\runtimes
if errorlevel neq 0 exit /b %errorlevel%

mv win-x64 ..
if errorlevel neq 0 exit /b %errorlevel%

mv win ..
if errorlevel neq 0 exit /b %errorlevel%

del /s *
if errorlevel neq 0 exit /b %errorlevel%

mv ..\win-x64 .
if errorlevel neq 0 exit /b %errorlevel%

mv ..\win .
if errorlevel neq 0 exit /b %errorlevel%

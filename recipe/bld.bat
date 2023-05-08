pushd src\windows\Installer.Windows\
if errorlevel 1 exit /b %errorlevel%

powershell -Command ".\layout.ps1 -Configuration WindowsRelease -Output payload -SymbolOutput symbols"
if errorlevel 1 exit /b %errorlevel%

popd

mkdir publishdir
if errorlevel 1 exit /b %errorlevel%

move src\windows\Installer.Windows\payload publishdir\payload
if errorlevel 1 exit /b %errorlevel%

move src\shared\DotnetTool\DotnetToolSettings.xml publishdir\payload
if errorlevel 1 exit /b %errorlevel%

mkdir publishdir\images\
if errorlevel 1 exit /b %errorlevel%

move src\shared\DotnetTool\icon.png publishdir\images\
if errorlevel 1 exit /b %errorlevel%

dir publishdir
dir publishdir\payload

rem Pack into dotnet tool such that the dlls won't spill into the %PREFIX%
dotnet pack src\shared\DotnetTool\DotnetTool.csproj ^
  /p:Configuration=Release ^
  /p:PackageVersion=%PKG_VERSION% ^
  /p:PublishDir=%SRC_DIR%\publishdir\ ^
  --runtime win-x64
if errorlevel 1 exit /b %errorlevel%

dotnet tool install git-credential-manager ^
  --tool-path %PREFIX%\dotnet\tools ^
  --add-source out\shared\DotnetTool\nupkg\Release
if errorlevel 1 exit /b %errorlevel%

del %PREFIX%\dotnet\tools\.store\%PKG_NAME%\%PKG_VERSION%\%PKG_NAME%\%PKG_VERSION%\%PKG_NAME%.%PKG_VERSION%.nupkg
if errorlevel 1 exit /b %errorlevel%

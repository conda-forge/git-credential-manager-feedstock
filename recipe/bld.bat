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
  /p:PublishDir=%SRC_DIR%\publishdir\
if errorlevel 1 exit /b %errorlevel%

pushd %SRC_DIR%\out\shared\DotnetTool\nupkg\Release
mkdir tmp
copy %PKG_NAME%.%PKG_VERSION%.nupkg %PKG_NAME%.%PKG_VERSION%.zip
powershell -Command "Expand-Archive .\%PKG_NAME%.%PKG_VERSION%.zip -DestinationPath .\tmp"
dir tmp
dir tmp\tools
dir tmp\tools\net6.0
dir tmp\tools\net6.0\any
popd

dotnet tool install git-credential-manager ^
  --tool-path %PREFIX%\dotnet\tools ^
  --add-source out\shared\DotnetTool\nupkg\Release
if errorlevel 1 exit /b %errorlevel%

del %PREFIX%\dotnet\tools\.store\%PKG_NAME%\%PKG_VERSION%\%PKG_NAME%\%PKG_VERSION%\%PKG_NAME%.%PKG_VERSION%.nupkg
if errorlevel 1 exit /b %errorlevel%

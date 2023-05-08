dotnet tool install git-credential-manager ^
  --tool-path %PREFIX%\dotnet\tools ^
  --add-source %SRC_DIR% ^
  --verbosity diagnostic

cd %PREFIX%\dotnet\tools\.store\%PKG_NAME%\%PKG_VERSION%\%PKG_NAME%\%PKG_VERSION%\tools\net6.0\any\runtimes
mv win-x64 ..
mv win ..
del /s *
mv ..\win-x64 .
mv ..\win .

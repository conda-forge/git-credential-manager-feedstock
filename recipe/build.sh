set -eoux pipefail

if [[ "${target_platform}" == "linux-64" ]]
then
  # Set correct install location
  sed -i -E 's|^\s*INSTALL_LOCATION="(.*)"$|    INSTALL_LOCATION="${PREFIX}"|g' ./src/linux/Packaging.Linux/build.sh
  # Set the correct version
  echo $(jq ".version = \"${PKG_VERSION}}\"" version.json) > version.json
  # Build app
  dotnet build ./src/linux/Packaging.Linux/Packaging.Linux.csproj -c Release -p:InstallFromSource=true
else
  dotnet tool install git-credential-manager \
    --tool-path "${PREFIX}/lib/dotnet/tools" \
    --add-source "${SRC_DIR}" \
    --verbosity diagnostic \
    ;
fi

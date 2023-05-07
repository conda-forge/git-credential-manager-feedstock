set -eoux pipefail

if [[ "${target_platform}" == linux-* ]]
then
  # Set the correct version
  echo '{"version": "'"${PKG_VERSION}"'"}' > version.json

  # Build app
  dotnet build ./src/linux/Packaging.Linux/Packaging.Linux.csproj \
    -c Release \
    -p:InstallFromSource=true \
    ;
else
  # Install script taken from
  # https://github.com/git-ecosystem/git-credential-manager/blob/release/src/linux/Packaging.Linux/build.sh

  INSTALL_TO="$PREFIX/share/gcm-core/"
  LINK_TO="$PREFIX/bin/"

  mkdir -p "$INSTALL_TO" "$LINK_TO"
  cp -R payload/* "$INSTALL_TO"

  # Create symlink
  ln -s "$INSTALL_TO/git-credential-manager" "$LINK_TO/git-credential-manager"

  # Create legacy symlink with older name
  ln -s "$INSTALL_TO/git-credential-manager" "$LINK_TO/git-credential-manager-core"
fi

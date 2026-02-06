set -eoux pipefail

if [[ "${target_platform}" == linux-64 ]]
then
  export RUNTIME="linux-x64"
elif [[ "${target_platform}" == linux-aarch64 ]]
then
  export RUNTIME="linux-arm64"
elif [[ "${target_platform}" == osx-arm64 ]]
then
  export RUNTIME="osx-arm64"
elif [[ "${target_platform}" == osx-64 ]]
then
  export RUNTIME="osx-x64"
else
  echo "Unknown target platform: ${target_platform}"
  exit 1
fi

if [[ "${target_platform}" == linux-* ]]
then
  export CONFIGURATION=LinuxRelease
  export PAYLOAD=out/linux/Packaging.Linux/"$CONFIGURATION"/payload
  src/linux/Packaging.Linux/layout.sh
elif [[ "${target_platform}" == osx-* ]]
then
  export CONFIGURATION=MacRelease
  export PAYLOAD=payload
  src/osx/Installer.Mac/layout.sh
else
  echo "Unknown target platform: ${target_platform}"
  exit 1
fi

# Install script taken from
# https://github.com/git-ecosystem/git-credential-manager/blob/release/src/linux/Packaging.Linux/build.sh

INSTALL_TO="$PREFIX/share/gcm-core/"
LINK_TO="$PREFIX/bin/"

mkdir -p "$INSTALL_TO" "$LINK_TO"
cp -R "$PAYLOAD"/* "$INSTALL_TO"

# Create symlink
ln -s "$INSTALL_TO/git-credential-manager" "$LINK_TO/git-credential-manager"

# Create legacy symlink with older name
ln -s "$INSTALL_TO/git-credential-manager" "$LINK_TO/git-credential-manager-core"

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

# Install script taken from
# https://github.com/git-ecosystem/git-credential-manager/blob/main/build/install-from-source.sh

if [[ "${target_platform}" == linux-* ]]
then
  publish_script=build/linux/publish.sh
elif [[ "${target_platform}" == osx-* ]]
then
  publish_script=build/macos/publish.sh
else
  echo "Unknown target platform: ${target_platform}"
  exit 1
fi

PAYLOAD="out/install-from-source/payload"

"$publish_script" \
  --configuration Release \
  --aot \
  --runtime "${RUNTIME}" \
  --output "${PAYLOAD}"

INSTALL_TO="$PREFIX/share/gcm-core/"
LINK_TO="$PREFIX/bin/"

mkdir -p "$INSTALL_TO" "$LINK_TO"
cp -R "$PAYLOAD"/* "$INSTALL_TO"

# Create symlink
ln -s "$INSTALL_TO/git-credential-manager" "$LINK_TO/git-credential-manager"

# Create legacy symlink with older name
ln -s "$INSTALL_TO/git-credential-manager" "$LINK_TO/git-credential-manager-core"

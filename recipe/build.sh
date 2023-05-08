set -eoux pipefail

dotnet tool install git-credential-manager \
  --tool-path "${PREFIX}/lib/dotnet/tools" \
  --add-source "${SRC_DIR}" \
  --verbosity diagnostic \
  ;

cd "${PREFIX}/lib/dotnet/tools"
cd ".store/${PKG_NAME}/${PKG_VERSION}/${PKG_NAME}/${PKG_VERSION}"
rm "${PKG_NAME}.${PKG_VERSION}.nupkg"

cd "tools/net6.0/any"
mv runtimes temp
mkdir runtimes

mv temp/unix runtimes/

if [[ "${target_platform}" == linux-64 ]]
then
  mv temp/linux-x64 runtimes/
elif [[ "${target_platform}" == linux-aarch64 ]]
then
  mv temp/linux-arm64 runtimes/
elif [[ "${target_platform}" == osx-* ]]
then
  mv temp/osx runtimes/
fi

rm -r temp

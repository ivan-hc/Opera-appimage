#!/bin/sh

APP=opera
mkdir tmp
cd ./tmp
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$(uname -m).AppImage -O appimagetool
chmod a+x ./appimagetool

VERSION=$(wget -q "https://get.geo.opera.com/pub/opera/desktop/" -O - | grep href | tail -n 1 | cut -d '"' -f 2 | cut -d / -f 1)
wget "https://get.geo.opera.com/pub/opera/desktop/$VERSION/linux/opera-stable_${VERSION}_amd64.deb"
ar x ./*.deb
tar xf ./data.tar.xz
mkdir $APP.AppDir
mv ./usr/lib/x86_64-linux-gnu/opera/* ./$APP.AppDir/
mv ./usr/share/applications/*.desktop ./$APP.AppDir/
sed -i -e '/TargetEnvironment/d' ./$APP.AppDir/*.desktop
mv ./usr/share/pixmaps/* ./$APP.AppDir/

cat >> ./$APP.AppDir/AppRun << 'EOF'
#!/bin/sh
APP=opera
HERE="$(dirname "$(readlink -f "${0}")")"
export UNION_PRELOAD="${HERE}"
exec "${HERE}"/$APP "$@"
EOF
chmod a+x ./$APP.AppDir/AppRun
ARCH=x86_64 ./appimagetool -n ./$APP.AppDir
cd ..
mv ./tmp/*AppImage ./Opera-Web-Browser-$VERSION-x86_64.AppImage
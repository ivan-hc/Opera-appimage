#!/bin/sh

APP=opera

# TEMPORARY DIRECTORY
mkdir -p tmp
cd ./tmp || exit 1

# DOWNLOAD APPIMAGETOOL
if ! test -f ./appimagetool; then
	wget -q "$(wget -q https://api.github.com/repos/probonopd/go-appimage/releases -O - | sed 's/"/ /g; s/ /\n/g' | grep -o 'https.*continuous.*tool.*86_64.*mage$')" -O appimagetool
	chmod a+x ./appimagetool
fi

# DOWNLOAD WIDEVINE
if ! test -f ./*.deb; then
	wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	ar x ./*.deb
	tar xf ./data.tar.xz
	mv ./opt/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so ./libwidevinecdm.so
fi

# DOWNLOAD A WORKING VERSION OF FFMPEG (THE ONE IN OPERA IS BROKEN...FROM YEARS)
if ! test -f ./*.zip; then
	wget "$(wget -q https://api.github.com/repos/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/latest -O - | grep browser_download_url | grep -i linux | grep -i 64 | cut -d '"' -f 4 | head -1)"
	unzip ./*.zip
fi

# CREATE OPERA BROWSER APPIMAGES

_create_opera_appimage(){
	if wget --version | head -1 | grep -q ' 1.'; then
		wget -q --no-verbose --show-progress --progress=bar "https://deb.opera.com/opera-stable/pool/non-free/o/$APP-$CHANNEL/$(wget -q https://deb.opera.com/"$APP"-"$CHANNEL"/pool/non-free/o/"$APP"-"$CHANNEL"/ -O - | grep deb | tail -1 | grep -o -P '(?<=.deb">).*(?=</a>)')"
	else
		wget "https://deb.opera.com/opera-stable/pool/non-free/o/$APP-$CHANNEL/$(wget -q https://deb.opera.com/opera-stable/pool/non-free/o/"$APP"-"$CHANNEL"/ -O - | grep deb | tail -1 | grep -o -P '(?<=.deb">).*(?=</a>)')"
	fi
	ar x ./*.deb
	tar xf ./data.tar.xz
	mkdir "$APP".AppDir
	mv ./usr/lib/x86_64-linux-gnu/oper*/* ./"$APP".AppDir/
	mv ./usr/share/applications/*.desktop ./"$APP".AppDir/
	sed -i -e '/TargetEnvironment/d' ./"$APP".AppDir/*.desktop
	mv ./usr/share/pixmaps/* ./"$APP".AppDir/
	cp ../libwidevinecdm.so ./"$APP".AppDir/
	mv ./"$APP".AppDir/libffmpeg.so ./"$APP".AppDir/libffmpeg.so.old
	cp ../libffmpeg.so ./"$APP".AppDir/
	tar xf ./control.tar.xz
	VERSION=$(cat control | grep Version | cut -c 10-)

	cat <<-'HEREDOC' >> ./"$APP".AppDir/AppRun
	#!/bin/sh
	APP=CHROME
	HERE="$(dirname "$(readlink -f "${0}")")"
	export UNION_PRELOAD="${HERE}"
	exec "${HERE}"/$APP "$@"
	HEREDOC
	chmod a+x ./"$APP".AppDir/AppRun
	if [ "$CHANNEL" = "stable" ]; then
		sed -i "s/CHROME/$APP/g" ./"$APP".AppDir/AppRun
	else
		sed -i "s/CHROME/$APP-$CHANNEL/g" ./"$APP".AppDir/AppRun
	fi
	ARCH=x86_64 VERSION=$(./appimagetool -v | grep -o '[[:digit:]]*') ./appimagetool -s ./"$APP".AppDir
	mv ./*.AppImage ./Opera-Web-Browser-"$CHANNEL"-"$VERSION"-x86_64.AppImage || exit 1
}

CHANNEL="stable"
mkdir -p "$CHANNEL" && cp ./appimagetool ./"$CHANNEL"/appimagetool && cd "$CHANNEL" || exit 1
_create_opera_appimage
cd ..
mv ./"$CHANNEL"/*.AppImage ./

CHANNEL="beta"
mkdir -p "$CHANNEL" && cp ./appimagetool ./"$CHANNEL"/appimagetool && cd "$CHANNEL" || exit 1
_create_opera_appimage
cd ..
mv ./"$CHANNEL"/*.AppImage ./

CHANNEL="developer"
mkdir -p "$CHANNEL" && cp ./appimagetool ./"$CHANNEL"/appimagetool && cd "$CHANNEL" || exit 1
_create_opera_appimage
cd ..
mv ./"$CHANNEL"/*.AppImage ./

cd ..
mv ./tmp/*.AppImage ./

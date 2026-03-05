#!/bin/sh

APP=opera

# TEMPORARY DIRECTORY
mkdir -p tmp
cd ./tmp || exit 1

# DOWNLOAD APPIMAGETOOL
if ! test -f ./appimagetool; then
	wget -q https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool || exit 1
	chmod a+x ./appimagetool
fi

# DOWNLOAD WIDEVINE
if ! test -f ./*.deb; then
	wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || exit 1
	ar x ./*.deb
	tar xf ./data.tar.xz
	mv ./opt/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so ./libwidevinecdm.so || exit 1
fi

# DOWNLOAD A WORKING VERSION OF FFMPEG (THE ONE IN OPERA IS BROKEN...FROM YEARS)
if ! test -f ./*.zip; then
	wget "$(curl -Ls https://api.github.com/repos/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/latest | sed 's/[()",{} ]/\n/g' | grep -oi "https.*linux.*64.*zip$" | head -1)" || exit 1
	unzip ./*.zip || exit 1
fi

# CREATE OPERA BROWSER APPIMAGES

_create_opera_appimage(){
	if wget --version | head -1 | grep -q ' 1.'; then
		wget -q --no-verbose --show-progress --progress=bar "https://deb.opera.com/opera-stable/pool/non-free/o/$APP-$CHANNEL/$(wget -q https://deb.opera.com/"$APP"-"$CHANNEL"/pool/non-free/o/"$APP"-"$CHANNEL"/ -O - | grep deb | tail -1 | grep -o -P '(?<=.deb">).*(?=</a>)')" || exit 1
	else
		wget "https://deb.opera.com/opera-stable/pool/non-free/o/$APP-$CHANNEL/$(wget -q https://deb.opera.com/opera-stable/pool/non-free/o/"$APP"-"$CHANNEL"/ -O - | grep deb | tail -1 | grep -o -P '(?<=.deb">).*(?=</a>)')" || exit 1
	fi
	ar x ./*.deb
	tar xf ./data.tar.xz
	mkdir "$APP".AppDir
	mv ./usr/lib/x86_64-linux-gnu/oper*/* ./"$APP".AppDir/ || exit 1
	mv ./usr/share/applications/*.desktop ./"$APP".AppDir/ || exit 1
	sed -i -e '/TargetEnvironment/d' ./"$APP".AppDir/*.desktop
	mv ./usr/share/pixmaps/* ./"$APP".AppDir/ || exit 1
	cp ../libwidevinecdm.so ./"$APP".AppDir/ || exit 1
	mv ./"$APP".AppDir/libffmpeg.so ./"$APP".AppDir/libffmpeg.so.old || exit 1
	cp ../libffmpeg.so ./"$APP".AppDir/ || exit 1
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
	ARCH=x86_64 ./appimagetool --comp zstd --mksquashfs-opt -Xcompression-level --mksquashfs-opt 20 \
	-u "gh-releases-zsync|$GITHUB_REPOSITORY_OWNER|Opera-appimage|continuous|*-$CHANNEL-*x86_64.AppImage.zsync" \
	./"$APP".AppDir Opera-Web-Browser-"$CHANNEL"-"$VERSION"-x86_64.AppImage || exit 1
}

CHANNEL="stable"
mkdir -p "$CHANNEL" && cp ./appimagetool ./"$CHANNEL"/appimagetool && cd "$CHANNEL" || exit 1
_create_opera_appimage
cd .. || exit 1
mv ./"$CHANNEL"/*.AppImage* ./

CHANNEL="beta"
mkdir -p "$CHANNEL" && cp ./appimagetool ./"$CHANNEL"/appimagetool && cd "$CHANNEL" || exit 1
_create_opera_appimage
cd .. || exit 1
mv ./"$CHANNEL"/*.AppImage* ./

CHANNEL="developer"
mkdir -p "$CHANNEL" && cp ./appimagetool ./"$CHANNEL"/appimagetool && cd "$CHANNEL" || exit 1
_create_opera_appimage
cd .. || exit 1
mv ./"$CHANNEL"/*.AppImage* ./

cd ..
mv ./tmp/*.AppImage* ./

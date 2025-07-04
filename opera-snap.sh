#!/bin/sh

APP=opera

# TEMPORARY DIRECTORY
mkdir -p tmp
cd ./tmp || exit 1

# DOWNLOAD APPIMAGETOOL
if ! test -f ./appimagetool; then
	wget -q https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
	chmod a+x ./appimagetool
fi

# CREATE CHROMIUM BROWSER APPIMAGES

_create_opera_appimage() {
	# DOWNLOAD THE SNAP PACKAGE
	if ! test -f ./*.snap; then
		if wget --version | head -1 | grep -q ' 1.'; then
			wget -q --no-verbose --show-progress --progress=bar "$(curl -H 'Snap-Device-Series: 16' http://api.snapcraft.io/v2/snaps/info/opera$BRANCH --silent | sed 's/\[{/\n/g; s/},{/\n/g' | grep -i "stable" | head -1 | sed 's/[()",{} ]/\n/g' | grep "^http")"
		else
			wget "$(curl -H 'Snap-Device-Series: 16' http://api.snapcraft.io/v2/snaps/info/opera$BRANCH --silent | sed 's/\[{/\n/g; s/},{/\n/g' | grep -i "stable" | head -1 | sed 's/[()",{} ]/\n/g' | grep "^http")"
		fi
	fi

	# EXTRACT THE SNAP PACKAGE AND CREATE THE APPIMAGE
	unsquashfs -f ./*.snap
	mkdir -p "$APP".AppDir
	VERSION=$(cat ./squashfs-root/meta/*.yaml | grep "^version" | head -1 | cut -c 10-)

	mv ./squashfs-root/etc ./"$APP".AppDir/
	mv ./squashfs-root/lib ./"$APP".AppDir/
	mv ./squashfs-root/usr ./"$APP".AppDir/
	mv ./squashfs-root/bin ./"$APP".AppDir/
	cp -r ./"$APP".AppDir/usr/share/icons/hicolor/256x256/apps/*.png ./"$APP".AppDir/
	cp -r ./"$APP".AppDir/usr/share/applications/*.desktop ./"$APP".AppDir/
	sed -i 's#${SNAP}/usr/share/icons/hicolor/256x256/apps/opera#opera#g' ./"$APP".AppDir/*.desktop
	sed -i 's/\.png//g' ./"$APP".AppDir/*.desktop
	sed -i 's/TargetEnvironment/X-TargetEnvironment/g' ./"$APP".AppDir/*.desktop

	cat <<-'HEREDOC' >> ./"$APP".AppDir/AppRun
	#!/bin/sh
	APP=CHROME
	HERE="$(dirname "$(readlink -f "${0}")")"
	export UNION_PRELOAD="${HERE}"
	exec "${HERE}"/usr/lib/x86_64-linux-gnu/$APP/$APP "$@"
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

BRANCH=""
CHANNEL="stable"
mkdir -p "$CHANNEL" && cp ./appimagetool ./"$CHANNEL"/appimagetool && cd "$CHANNEL" || exit 1
_create_opera_appimage
cd ..
mv ./"$CHANNEL"/*.AppImage* ./

BRANCH="-developer"
CHANNEL="developer"
mkdir -p "$CHANNEL" && cp ./appimagetool ./"$CHANNEL"/appimagetool && cd "$CHANNEL" || exit 1
_create_opera_appimage
cd ..
mv ./"$CHANNEL"/*.AppImage* ./

BRANCH="-beta"
CHANNEL="beta"
mkdir -p "$CHANNEL" && cp ./appimagetool ./"$CHANNEL"/appimagetool && cd "$CHANNEL" || exit 1
_create_opera_appimage
cd ..
mv ./"$CHANNEL"/*.AppImage* ./

cd ..
mv ./tmp/*.AppImage* ./

# Opera-appimage
Unofficial AppImage for Opera Web Browser Stable, Beta and Developer

### Known issues

----------------

#### ◆ Language
As already suggested on [this page](https://forums.opera.com/topic/58114/can-t-change-ui-language-no-option-display-opera-in-that-language/12) run the AppImage fith the flag "--lang=$YOULANGUAGE" to made it work.

Instead, by installing this AppImage via "[AM](https://github.com/ivan-hc/AM-Application-Manager)" or "[AppMan](https://github.com/ivan-hc/AppMan)" the binary in $PATH is a script that launches the following command:

    opera --lang=$(echo $LANG | cut -c -2) %U
And this definitelly solves the issue.

----------------

#### ◆ Can't play videos on many sites
More banally, Ubuntu is switching all its packages to Snap, Opera developers are using an old ffmpeg in their deb package and none have updated it... so none cares about the deb version of Opera. All workaround seems to point to external third-party sources (see issue https://github.com/ivan-hc/Opera-appimage/issues/1).

However, until the deb package has no fixes, I can't update a "pure" AppImage. We need additional third-party libraries.

Those included in these AppImages are provided by https://github.com/nwjs-ffmpeg-prebuilt (`libffmpeg.so`) and from an official proprietary source (`libwidevinecdm.so`).

NOTE: Opera, Vivaldi, Brave, Google Chrome... are all browsers based on Chromium. Alternativelly use another web browser, like Brave or Vivaldi, they are multiplatform, privacy oriented and more supported than Opera (at least on the Linux-side). 

My version of Vivaldi is built in the same way of Opera, but everything works without issues, see [Vivaldi-appimage](https://github.com/ivan-hc/Vivaldi-appimage).

---------------------------------

## Install and update it with ease

I wrote two bash scripts to install and manage the applications: [AM](https://github.com/ivan-hc/AM-Application-Manager) and [AppMan](https://github.com/ivan-hc/AppMan). Their dual existence is based on the needs of the end user.

| [**"AM" Application Manager**](https://github.com/ivan-hc/AM-Application-Manager) |
| -- |
| <sub>***If you want to install system-wide applications on your GNU/Linux distribution in a way that is compatible with [Linux Standard Base](https://refspecs.linuxfoundation.org/lsb.shtml) (all third-party apps must be installed in dedicated directories under `/opt` and their launchers and binaries in `/usr/local/*` ...), just use ["AM" Application Manager](https://github.com/ivan-hc/AM-Application-Manager). This app manager requires root privileges only to install / remove applications, the main advantage of this type of installation is that the same applications will be available to all users of the system.***</sub>
[![Readme](https://img.shields.io/github/stars/ivan-hc/AM-Application-Manager?label=%E2%AD%90&style=for-the-badge)](https://github.com/ivan-hc/AM-Application-Manager/stargazers) [![Readme](https://img.shields.io/github/license/ivan-hc/AM-Application-Manager?label=&style=for-the-badge)](https://github.com/ivan-hc/AM-Application-Manager/blob/main/LICENSE)

| [**"AppMan"**](https://github.com/ivan-hc/AppMan)
| --
| <sub>***If you don't want to put your app manager in a specific path but want to use it portable and want to install / update / manage all your apps locally, download ["AppMan"](https://github.com/ivan-hc/AppMan) instead. With this script you will be able to decide where to install your applications (at the expense of a greater consumption of resources if the system is used by more users). AppMan is portable, all you have to do is write the name of a folder in your `$HOME` where you can install all the applications available in [the "AM" database](https://github.com/ivan-hc/AM-Application-Manager/tree/main/programs), and without root privileges.***</sub>
[![Readme](https://img.shields.io/github/stars/ivan-hc/AppMan?label=%E2%AD%90&style=for-the-badge)](https://github.com/ivan-hc/AppMan/stargazers) [![Readme](https://img.shields.io/github/license/ivan-hc/AppMan?label=&style=for-the-badge)](https://github.com/ivan-hc/AppMan/blob/main/LICENSE)

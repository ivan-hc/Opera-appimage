# Opera-appimage
Unofficial AppImage for Opera Web Browser Stable, Beta and Developer

--------------------------------------------------
### NOTE: This wrapper is not verified by, affiliated with, or supported by Opera Corporation.

**The base software is under a proprietary license and unofficially repackaged as an AppImage for demonstration purposes, for the original authors, to promote this packaging format to them. Consider this package as "experimental". I also invite you to request the authors to release an official AppImage, and if they agree, you can show this repository as a proof of concept.**

--------------------------------------------------

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

However, until the deb package has no fixes, I can't update a "pure" AppImage. We need additional third-party libraries. Those included in these AppImages are provided by https://github.com/nwjs-ffmpeg-prebuilt (`libffmpeg.so`) and from an official proprietary source (`libwidevinecdm.so`).

This is why I switched the base to the Snap package... but it sometime has the same problem.

NOTE: Opera, Vivaldi, Brave, Google Chrome... are all browsers based on Chromium. Alternativelly use another web browser, like Brave or Vivaldi, they are multiplatform, privacy oriented and more supported than Opera (at least on the Linux-side). 

My version of Vivaldi is built in the same way of Opera, but everything works without issues, see [Vivaldi-appimage](https://github.com/ivan-hc/Vivaldi-appimage).

------------------------------------------------------------------------

## Install and update them all with ease

### *"*AM*" Application Manager* 
#### *Package manager, database & solutions for all AppImages and portable apps for GNU/Linux!*

[![sample.png](https://raw.githubusercontent.com/ivan-hc/AM/main/sample/sample.png)](https://github.com/ivan-hc/AM)

[![Readme](https://img.shields.io/github/stars/ivan-hc/AM?label=%E2%AD%90&style=for-the-badge)](https://github.com/ivan-hc/AM/stargazers) [![Readme](https://img.shields.io/github/license/ivan-hc/AM?label=&style=for-the-badge)](https://github.com/ivan-hc/AM/blob/main/LICENSE)

*"AM"/"AppMan" is a set of scripts and modules for installing, updating, and managing AppImage packages and other portable formats, in the same way that APT manages DEBs packages, DNF the RPMs, and so on... using a large database of Shell scripts inspired by the Arch User Repository, each dedicated to an app or set of applications.*

*The engine of "AM"/"AppMan" is the "APP-MANAGER" script which, depending on how you install or rename it, allows you to install apps system-wide (for a single system administrator) or locally (for each user).*

*"AM"/"AppMan" aims to be the default package manager for all AppImage packages, giving them a home to stay.*

*You can consult the entire **list of managed apps** at [**portable-linux-apps.github.io/apps**](https://portable-linux-apps.github.io/apps).*

## *Go to *https://github.com/ivan-hc/AM* for more!*

------------------------------------------------------------------------

| [***Install "AM"***](https://github.com/ivan-hc/AM) | [***See all available apps***](https://portable-linux-apps.github.io) | [***Support me on ko-fi.com***](https://ko-fi.com/IvanAlexHC) | [***Support me on PayPal.me***](https://paypal.me/IvanAlexHC) |
| - | - | - | - |

------------------------------------------------------------------------

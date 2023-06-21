# Opera-appimage
Unofficial AppImage for Opera Web Browser

### Known issue
As already suggested on [this page](https://forums.opera.com/topic/58114/can-t-change-ui-language-no-option-display-opera-in-that-language/12) run the AppImage fith the flag "--lang=$YOULANGUAGE" to made it work.

Instead, by installing this AppImage via "[AM](https://github.com/ivan-hc/AM-Application-Manager)" or "[AppMan](https://github.com/ivan-hc/AppMan)" the binary in $PATH is a script that launches the following command:

    opera --lang=$(echo $LANG | cut -c -2) %U


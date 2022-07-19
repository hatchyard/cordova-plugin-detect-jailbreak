# cordova-plugin-detect-jailbreak
This is a cordova plugin for **iOS** to detect whether our device is jailbreak or not. This is very useful plugin for critically and commercially important applications to avoid the usage of jailbroken users which might halmful for those systems.

You can use following line to call the plugin
```
DetectJailbreak.detectJailbreak(successCallback, errorCallback);
```

You can access the callbacks like following code.
```
function successCallback(isJailbroken) {
    console.log("This is success callback & jailbreak status: ", isJailbroken);
}

function errorCallback(error) {
    console.log("This is error: ", error);
}
```


#import "Cordova/CDV.h"
#import "Cordova/CDVViewController.h"
#import "DetectJailbreak.h"
#import <sys/stat.h>
#import <sys/sysctl.h>

static inline bool sandbox_integrity_compromised(void) __attribute__((always_inline));
static inline bool jailbreak_file_check(void) __attribute__((always_inline));
static inline bool symbolic_linking_check(void) __attribute__((always_inline));

@implementation DetectJailbreak

- (void) detectJailbreak:(CDVInvokedUrlCommand*)command;
{
    CDVPluginResult *pluginResult;

    @try
    {
        bool jailbroken = [self jailbroken];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:jailbroken];
    
    }
    @catch (NSException *exception)
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
    }
    @finally
    {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

 - (bool) jailbroken {
     
     return (jailbreak_file_check() ||
             symbolic_linking_check() || sandbox_integrity_compromised());
 }

@end

bool sandbox_integrity_compromised(){
    int result = fork();
    if (!result)  /* The child should exit, if it spawned */
        exit(0);
    
    if (result >= 0) { /* If the fork succeeded, we're jailbroken */
        return true;
    }
    else {
        return false;
    }
}

bool jailbreak_file_check(){
    struct stat s;
    if (!stat("/Applications/Cydia.app", &s)) {
        return true;
    }
    else if (!stat("/Library/MobileSubstrate/MobileSubstrate.dylib", &s)) {
        return true;
    }
    else if (!stat("/var/cache/apt", &s)) {
        return true;
    }
    else if (!stat("/var/lib/cydia", &s)) {
        return true;
    }
    else if (!stat("/var/log/syslog", &s)) {
        return true;
    }
    else if (!stat("/var/tmp/cydia.log", &s)) {
        return true;
    }
   else if (!stat("/bin/bash", &s)) {
       return true;
   }
   else if (!stat("/bin/sh", &s)) {
       return true;
   }
   else if (!stat("/usr/sbin/sshd", &s)) {
       return true;
   }
   else if (!stat("/usr/libexec/ssh-keysign", &s)) {
       return true;
   }
   else if (!stat("/etc/ssh/sshd_config", &s)) {
       return true;
   }
    else if (!stat("/etc/apt", &s)) {
        return true;
    }
    
    return false;
}

bool symbolic_linking_check(){
    struct stat s;
    if (!lstat("/Applications", &s)) {
        if (s.st_mode & S_IFLNK) return true;
    }
    else if (!lstat("/Library/Ringtones", &s)) {
        if (s.st_mode & S_IFLNK) return true;
    }
    else if (!lstat("/Library/Wallpaper", &s)) {
        if (s.st_mode & S_IFLNK) return true;
    }
    else if (!lstat("/usr/arm-apple-darwin9", &s)) {
        if (s.st_mode & S_IFLNK) return true;
    }
    else if (!lstat("/usr/include", &s)) {
        if (s.st_mode & S_IFLNK) return true;
    }
    else if (!lstat("/usr/libexec", &s)) {
        if (s.st_mode & S_IFLNK) return true;
    }
    else if (!lstat("/usr/share", &s)) {
        if (s.st_mode & S_IFLNK) return true;
    }
    
    return false;
}
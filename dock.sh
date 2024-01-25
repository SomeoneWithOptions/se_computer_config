#!/bin/bash

dockutil="/usr/local/bin/dockutil"
loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
LoggedInUserHome="/Users/$loggedInUser"
UserPlist=$LoggedInUserHome/Library/Preferences/com.apple.dock.plist

installer_path=~/installers

if [[ $(id -u) -ne 0 ]]
then
    echo "Please run as sudo"
    exit 1
fi

if [[ -d $installer_path ]]
then
    echo "installer path Exists" 
else 
    mkdir $installer_path
    echo "installer path created"
fi

curl -fsSL https://github.com/kcrawford/dockutil/releases/download/3.1.1/dockutil-3.1.1.pkg -o $installer_path/dockutil.pkg

installer -pkg $installer_path/dockutil.pkg -target /

if [ -f /usr/local/bin/dockutil ]
then    
    echo "dockutil installation successful"
else    
    echo "dockutil installation failed"
    exit 1
fi 

sudo -u $loggedInUser $dockutil --remove all --no-restart $UserPlist
sudo -u $loggedInUser $dockutil --add "/Applications/Google Chrome.app" --no-restart $UserPlist
sudo -u $loggedInUser $dockutil --add "/Applications/Slack.app/" --no-restart $UserPlist
sudo -u $loggedInUser $dockutil --add /System/Applications/System\ Settings.app --position end --no-restart $UserPlist
sudo -u $loggedInUser killall Dock

rm -rf $installer_path
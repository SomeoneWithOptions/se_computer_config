#!/bin/bash

loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
LoggedInUserHome="/Users/$loggedInUser"
UserPlist=$LoggedInUserHome/Library/Preferences/com.apple.dock.plist

echo using $loggedInUser to run commands

# APP INSTALLATION
if ! command -v brew &> /dev/null
then
    sudo -u $loggedInUser /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    sudo -u $loggedInUser echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc
    sudo -u $loggedInUser source ~/.zshrc
fi

sudo -u $loggedInUser brew install bash
sudo -u $loggedInUser brew install --cask google-chrome
sudo -u $loggedInUser brew install --cask slack
sudo -u $loggedInUser brew install --cask microsoft-office
sudo -u $loggedInUser brew install dockutil 

curl https://installers-stellar.s3.us-east-2.amazonaws.com/Endpoint.dmg --output ~/Downloads/bitdefender.dmg

echo "Apps Installation Finished"

# END APP INSTALLATION

# CHANGE HOSTNAME 

if [ -z $name ] ; then
    read -p "Please enter the Computername" name 
fi

echo computername will be \"$name\"
sudo scutil --set HostName $name
sudo scutil --set LocalHostName $name 
sudo scutil --set ComputerName $name

echo "Hostname Changed to $name" 

# END CHANGE HOSTNAME

# CREATE ADMIN USER 

sudo dscl . -delete /Users/p202admin

if [ -d /Users/p202admin ]; then
    sudo rm -rf /Users/p202admin
fi

sudo sysadminctl -addUser p202admin -fullName "P202 Admin" -password p202wmsms! -admin

echo "Admin User Created"

# END CREATE ADMIN USER

# DOCK CONFIGURATION 

sudo -u $loggedInUser dockutil --add "/Applications/Google Chrome.app" --no-restart $UserPlist
sudo -u $loggedInUser dockutil --add "/Applications/Slack.app/" --no-restart $UserPlist
sudo -u $loggedInUser dockutil --add /System/Applications/System\ Settings.app --position end --no-restart $UserPlist
sudo -u $loggedInUser killall Dock

echo "Dock Configuration Finished"

# END DOCK CONFIGURATION

#ENABLE FIREVAULT 

fdeStatus=$(fdesetup status)
if [[ $fdeStatus == "FileVault is Off" ]]; then
    fdesetup enable -user $loggedInUser -defer /private/var/root/recovery.plist -keychain -forceatlogin
    logout
    echo "FileVault is not enabled. Logging off the user in 3 seconds to force FileVault activation."
    sleep 3
    logout
else
    echo "FileVault is enabled."
fi

# END ENABLE FIREVAULT
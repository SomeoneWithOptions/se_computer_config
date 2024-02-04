#!/bin/bash

# APP INSTALLATION
if ! command -v brew &> /dev/null
then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc
    source ~/.zshrc
fi

brew install bash
brew install --cask google-chrome
brew install --cask slack
brew install --cask microsoft-office
brew install dockutil 

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

echo "Hostname Changed" 

# END CHANGE HOSTNAME

# CREATE ADMIN USER 

sudo dscl . -delete /Users/p202admin

if [ -d /Users/p202admin ]; then
    sudo rm -rf /Users/p202admin
fi

sudo sysadminctl -addUser p202admin -fullName "P202 Admin" -password p202wmsms! -admin

# END CREATE ADMIN USER

# DOCK CONFIGURATION 

loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
LoggedInUserHome="/Users/$loggedInUser"
UserPlist=$LoggedInUserHome/Library/Preferences/com.apple.dock.plist

sudo -u $loggedInUser dockutil --remove all --no-restart $UserPlist
sudo -u $loggedInUser dockutil --add "/Applications/Google Chrome.app" --no-restart $UserPlist
sudo -u $loggedInUser dockutil --add "/Applications/Slack.app/" --no-restart $UserPlist
sudo -u $loggedInUser dockutil --add /System/Applications/System\ Settings.app --position end --no-restart $UserPlist
sudo -u $loggedInUser killall Dock

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
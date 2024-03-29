#!/bin/bash

loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
LoggedInUserHome="/Users/$loggedInUser"
UserPlist=$LoggedInUserHome/Library/Preferences/com.apple.dock.plist

# CREATE ADMIN USER

sudo dscl . -delete /Users/p202admin

if [ -d /Users/p202admin ]; then
    sudo rm -rf /Users/p202admin
fi

sudo sysadminctl -addUser p202admin -fullName "P202 Admin" -password p202wmsms! -admin

# END CREATE ADMIN USER

# CHANGE HOSTNAME

sudo scutil --set HostName $loggedInUser
sudo scutil --set LocalHostName $loggedInUser
sudo scutil --set ComputerName $loggedInUser

# END CHANGE HOSTNAME

# APP INSTALLATION

if ! command -v brew &> /dev/null
then
    sudo -u $loggedInUser /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    sudo -u $loggedInUser echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$loggedInUser/.zprofile
    echo "Wrote to File /Users/$loggedInUser/.zprofile"
    sudo -u $loggedInUser /opt/homebrew/bin/brew --version
fi

sudo -u $loggedInUser /opt/homebrew/bin/brew install bash
sudo -u $loggedInUser /opt/homebrew/bin/brew install --cask firefox
sudo -u $loggedInUser /opt/homebrew/bin/brew install --cask google-chrome
sudo -u $loggedInUser /opt/homebrew/bin/brew install --cask slack
sudo -u $loggedInUser /opt/homebrew/bin/brew install --cask microsoft-office
sudo -u $loggedInUser /opt/homebrew/bin/brew install dockutil
sudo -u $loggedInUser /opt/homebrew/bin/brew install --cask visual-studio-code
sudo -u $loggedInUser /opt/homebrew/bin/brew install --cask appcleaner

curl https://installers-stellar.s3.us-east-2.amazonaws.com/Endpoint.dmg --output ~/Downloads/bitdefender.dmg

# END APP INSTALLATION

# DOCK CONFIGURATION

sudo -u $loggedInUser /opt/homebrew/bin/dockutil --remove all --no-restart $UserPlist
sudo -u $loggedInUser /opt/homebrew/bin/dockutil --add "/Applications/Google Chrome.app" --no-restart $UserPlist
sudo -u $loggedInUser /opt/homebrew/bin/dockutil --add "/Applications/Slack.app/" --no-restart $UserPlist
sudo -u $loggedInUser /opt/homebrew/bin/dockutil --add /System/Applications/System\ Settings.app --position end --no-restart $UserPlist
sudo -u $loggedInUser defaults write com.apple.dock show-recents -bool FALSE ;
sudo -u $loggedInUser killall Dock

# END DOCK CONFIGURATION

# ENABLE FIREVAULT

fstatus=$(fdesetup status | grep -i "on")

if [[ -n $fstatus ]]; then
    echo "Firevault is Already ON"
fi

sudo fdesetup enable -user $loggedInUser

# END ENABLE FIREVAUT
#!/bin/bash

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

echo "installation finished"
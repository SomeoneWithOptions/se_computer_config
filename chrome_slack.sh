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

echo "Homebrew, chrome and slack have been installed successfully!"

#!/bin/bash 

sudo dscl . -delete /Users/p202admin

if [ -d /Users/p202admin ]; then
    sudo rm -rf /Users/p202admin
fi

sudo sysadminctl -addUser p202admin -fullName "P202 Admin" -password p202wmsms! -admin
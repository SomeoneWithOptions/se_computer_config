#!/bin/sh
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
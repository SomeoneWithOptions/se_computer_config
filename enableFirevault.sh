#!/bin/sh

loggedInUser=$( ls -l /dev/console | awk '{print $3}' )

fstatus=$(fdesetup status | grep -i "on")
echo $fstatus

if [[ -n $fstatus ]]; then
    echo "Firevault is Already ON"
fi

sudo fdesetup enable -user $loggedInUser
sudo fdesetup changerecovery -personal -output ~/r

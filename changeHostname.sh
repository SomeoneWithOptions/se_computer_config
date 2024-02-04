#!/bin/bash

if [ -z $name ] 
then
read -p "Please enter the Computername" name 
fi
echo computername will be \"$name\"
sudo scutil --set HostName $name
sudo scutil --set LocalHostName $name 
sudo scutil --set ComputerName $name
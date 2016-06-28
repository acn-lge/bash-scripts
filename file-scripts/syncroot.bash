#!/bin/bash

 

export BASEODROOT="/cygdrive/c/Users/larry.esmonde/OneDrive - Accenture Federal Services/Census HR LOB/Demo-Website-Files/ROOT"
export BASEWAROOT="/cygdrive/c/Program Files/Apache Software Foundation/Tomcat 6.0/webapps/ROOT"

ONEDRIVEROOT=${ONEDRIVEROOT:-$BASEODROOT}
WEBAPPSROOT=${WEBAPPROOT:-$BASEWAROOT}

if [ ! -d "$ONEDRIVEROOT" ]; then
    echo "Unable to find OneDrive ROOT folder [$ONEDRIVEROOT]"
    exit 1
fi

if [ ! -d "$WEBAPPSROOT" ]; then
    echo "Unable to find OneDrive ROOT folder [$WEBAPPSROOT]"
    exit 1
fi

findrsync=`which rsync`

if [ "$findrsync" = "" ]; then
    echo "rsync command not in path"
    exit 1
fi


read -p "Syncing from OneDrive down to Tomcat. Hit [Enter] to start or [Ctrl-C] to abort" dumy
cd "$ONEDRIVEROOT"
rsync -zarRP * "$WEBAPPSROOT"
user=`whoami`
if [ "$user" = "larry.esmonde" ]; then
    chown -R SYSTEM:Domain\ Users "$WEBAPPSROOT"/*
fi

read -p "Syncing from Tomcat up to OneDrive. Hit [Enter] to start or [Ctrl-C] to abort" dumy
cd "$WEBAPPSROOT"
rsync -zarRP * "$ONEDRIVEROOT"

exit 0


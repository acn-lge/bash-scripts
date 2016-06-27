#!/bin/bash

if [ "$1" = "" -o "$2" = "" ]; then
    echo "usage: promote.bash <file-to-promote> <target-directory>"
    exit 1
fi


srcfilenm="$1"
tgtdirnm="$2"
pdate=`date +"%Y%m%d-%H%M%S"`
tgtfilenm="$tgtdirnm/$srcfilenm"
archfilenm="$tgtdirnm/$srcfilenm.$pdate"


#
#  With two confirmed parameters, do the sanity checks (we have the
#  source file at hand, we can see the target directory and we can
#  write to it)
#

if [ ! -f "$srcfilenm" ]; then
    echo "ERROR: Cannot open source file [$srcfilenm]"
    echo "ERROR: Exiting"
    exit 1
fi

if [ ! -d "$tgtdirnm" ]; then
    echo "ERROR: Cannot open target directory [$tgtdirnm]"
    echo "ERROR: Exiting"
    exit 1
fi

if [ ! -w "$tgtdirnm" ]; then
    echo "ERROR: Cannot write to target directory [$tgtdirnm]"
    echo "ERROR: Exiting"
    exit 1
fi

#
#  Check to see if a copy of the source file already exists
#  in the target directory.  If it does, check to see if
#  we can write to it.
#
tgtexists=0
if [ -f "$tgtfilenm" ]; then
    tgtexists=1
    if [ ! -w "$tgtfilenm" ]; then
        echo "ERROR: Cannot modify existing file in target directory [$tgtfilenm]"
        echo "ERROR: Cannot promote source file [$srcfilenm] to target directory"
        echo "ERROR: Exiting"
        exit 1
    fi
fi

#
#  All the sanity checks are finished.  Time to move files
#

if [ -f "$tgtfilenm" ]; then
    \mv $tgtfilenm $archfilenm
    rc=$?
else
    rc=0
fi

if [ "$rc" != "0" ]; then
    echo "ERROR: Unable to move existing file [$tgtfilenm] to archive name [$archfilenm]"
    echo "ERROR: Check current state of target directory [$tgtdirnm]"
    echo "ERROR: Exiting"
    exit 1
fi

\cp $srcfilenm $tgtfilenm
rc=$?

if [ "$rc" != "0" ]; then
    echo "ERROR: Unable to move existing file [$tgtfilenm] to archive name [$archfilenm]"
    echo "ERROR: Check current state of target directory [$tgtdirnm]"
    echo "ERROR: Exiting"
    exit 1
fi

echo "Local file [$srcfilenm] promoted to directory [$tgtdirnm]"
if [ "$tgtexists" = "1" ]; then
    echo "Existing file archived to [$archfilenm]"
fi

exit 0




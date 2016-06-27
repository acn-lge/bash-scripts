#!/bin/bash
if [ "$*" != "" ]; then
    cp -i $*
fi
exit $?

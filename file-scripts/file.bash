#!/bin/bash
if [ "$*" != "" ]; then
    file "$*"
fi
exit $?

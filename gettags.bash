#!/bin/bash

if [ "$1" = "-c" ]; then
    grep "#" $2 | awk 'BEGIN{FS="|"}{if (NF==18) tf=$6; else tf=$4; p=split(tf,a," "); f=a[1]; count[f]++; for (i=2; i <= p; i++) { f=a[i]; count[f]++; } }END{for (j in count) {print j,",",count[j];}}' | sort
elif [ "$1" = "-v" ]; then
    grep "#" $2 | awk 'BEGIN{FS="|"}{if (NF==18) tf=$6; else tf=$4; p=split(tf,a," "); print a[1]; for (i=2; i <= p; i++) { print a[i];} }' 
else
    grep "#" $1 | awk 'BEGIN{FS="|"}{if (NF==18) tf=$6; else tf=$4; p=split(tf,a," "); print a[1]; for (i=2; i <= p; i++) { print a[i];} }' | sort -u
fi

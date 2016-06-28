#!/bin/bash
if [ "$*" = "-h" ]; then 
    echo "usage: helloworld.bash"
    exit 1
fi

echo "Hello, world."
exit 0

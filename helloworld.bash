#!/bin/bash
if [ "$*" = "-h" ]; then 
    echo "usage: helloworld.bash"
    exit 1
fi

echo "Hello, world."
echo "Goodbye, world."
exit 0

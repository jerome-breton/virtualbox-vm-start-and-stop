#!/bin/bash

if [ "$1" = "-h" ]; then
    echo ""
    echo "  Usage : $0 [-h] [\"VM Name\"] [--sleep]"
    echo ""
    echo "    -h         Display this help"
    echo "    \"VM Name\"  Name of the VirtualBox machine to start"
    echo "    --sleep    Put VM to sleep instead of powering it off"
    exit 1
fi

if [ "vm$1" = "vm" ]; then
    echo ""
    echo "  This script require a VirtualBox VMName as a parameter."
    echo "    ie: $0 \"VM Name\""
    echo ""
    echo "  Use $0 -h for more help."
    exit 1
fi

# Launch a sleeping child process that will be "waited" next
sleep 2147483647 & PID=$!

# Trap "graceful" kills and use them to kill the sleeping child
trap "kill $PID" TERM

# Launch a subprocess not attached to this script that will trigger
# commands after its end
( sh -c "
    # Watch main script PID. Sleep duration can be ajusted
    # depending on reaction speed you want
    while ps -p $$ > /dev/null ; do
       sleep 3
    done

    # Kill the infinite sleep if it's still running
    if ps -p $PID > /dev/null ; then
        kill $PID
    fi

    # Commands to launch after any stop
    if [ \"$2\" = \"--sleep\" ]; then
        vboxmanage controlvm \"$1\" savestate
    else
        vboxmanage controlvm \"$1\" poweroff
    fi

" & )

# Commands to launch before waiting
echo "Starting $1"
vboxmanage startvm "$1"

# Waiting for infinite sleep to end...
wait

# Commands to launch after graceful stop
echo "Graceful ending $1"

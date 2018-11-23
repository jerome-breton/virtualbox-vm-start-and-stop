VirtualBox VM Start and Stop script
===================================

This script is launching the VirtualBox VM of your choice then shut it down when the script is interupted or killed.

I personnaly use it with IntelliJ IDEA to launch/stop the VM on project opening/closing.

Usage :
-------

### Linux/MacOS

    ./vm-start-and-stop.sh [-h] ["VM Name"] [--sleep]

    -h         Display help
    "VM Name"  Name of the VirtualBox machine to start
    --sleep    Put VM to sleep instead of powering it off

### Windows

You might need to edit VirtualBox path in the script, then :

    vm-start-and-stop.cmd [-h] ["VM Name"] [--sleep]

    -h         Display help
    "VM Name"  Name of the VirtualBox machine to start
    --sleep    Put VM to sleep instead of powering it off

Unfortunately, I cannot get rid of the minimified console opening. It must stay opened for VM to shutdown.


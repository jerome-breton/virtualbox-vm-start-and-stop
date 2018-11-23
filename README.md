VirtualBox VM Start and Stop script
===================================

This script is launching the VirtualBox VM of your choice then shut it down when the script is interupted or killed.

I personnaly use it with IntelliJ IDEA to launch/stop the VM on project opening/closing.

Usage:
------

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

Use with IntelliJ IDEA:
-----------------------

1. Open *Settings* (Ctrl+Alt+S)
2. Goto *Tools/Startup Tasks*
3. Click on **[+]** then *Add New Configuration*, then *HTTP Request*
4. Configure it:
    * **Name:** VM (or anything you want, it is not shared upon projects)
    * **Environment:** <No Environment>
    * **File:** Go grab the dummy.http in the resource folder of this repo (it will fire a dummy HTTP request on example.com)
    * **Request:** #1
5. Click on **[+]** in *Before launch: Activate tool window*, then *Run External Tool*
6. Click on **[+]** and configure it:
    * **Name:** ProjectName's VM (or anything you want, but will be shared upon projects)
    * **Program:** Go grab the vm-start-and-stop script for your system
    * **Arguments:** "VM Name" --sleep
7. Validate and close every popup
8. You can now launch your VM from the Run/Debug drop down or close and reopen your project

_PS: I know there is alternatives with plugins that might be cleaner than this trick with HTTP request. You can on
Linux/MacOS use the [Bash plugin](https://plugins.jetbrains.com/plugin/4230-bashsupport) to directly configure the
script, or you can use any Run/debug template you want... But, this is the only solution that is native for all
IntelliJ versions (PhpStorm, RubyMind, PyCharm, etc.) and cross-os._

_Feel free to provide any better solution if you find one :)_

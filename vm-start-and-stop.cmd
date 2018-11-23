@echo off

set VBoxManage="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
set VMSASKEY=%RANDOM%

if "%1" == "-h" (
    echo ""
    echo "  Usage : %0 [-h] [\"VM Name\"] [--sleep]"
    echo ""
    echo "    -h         Display this help"
    echo "    \"VM Name\"  Name of the VirtualBox machine to start"
    echo "    --sleep    Put VM to sleep instead of powering it off"
    exit 1
)

if "vm%1" == "vm" (
    echo ""
    echo "  This script require a VirtualBox VMName as a parameter."
    echo "    ie: %0 \"VM Name\""
    echo ""
    echo "  Use %0 -h for more help."
    exit 1
)

::Main loop
if "%~1" neq "_start_" (
	::Start VM
	%VBoxManage% startvm %1
	::Creates and run a scheduled task to stop VM when lifesignals stop being received
	schtasks /Create /SC MONTHLY /TN "VmStartAndStop %1" /TR "cmd /c start /min %~f0 _start_ %1 %VMSASKEY% %2" /F
	schtasks /Run /TN "VmStartAndStop %1" /I
	::Lifeloop
:aliveloop
	::Send lifesignal
	waitfor /s 127.0.0.1 /si VBoxStartAndStopAlive%VMSASKEY% >NUL
	::Wait 2sec
	waitfor VBoxStartAndStopLoop%VMSASKEY% /t 2 2>NUL
	goto aliveloop
	exit /b
)

::Watch loop
shift /1

mode con: cols=25 lines=1
title This window will shutdown VM %1 when needed.
echo Please do not close it.
:waitloop
::Wait lifesignal
waitfor VBoxStartAndStopAlive%2 /t 5 >NUL
if "%ERRORLEVEL%"=="0" goto waitloop
::Deletes scheduled task
schtasks /Delete /TN "VmStartAndStop %1" /F
::Shutdown VM
if "%3"=="--sleep" (
    %VBoxManage% controlvm %1 savestate
) else (
    %VBoxManage% controlvm %1 poweroff
)
::Ends terminal
exit \b

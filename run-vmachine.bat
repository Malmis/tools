@echo off
set "QEMUDIR=C:\PROGRA~1\qemu"
set "QEMUBIN=qemu-system-x86_64.exe"
set "VDRIVE=vdisk.img"
set "NAME=Virtualmachine"
set "MEM=4G"
set "CPUCORES=-smp cores=2"
set "OPTIONS=-k sv -soundhw all -usb -netdev user,id=n0 -device rtl8139,netdev=n0 -rtc base=localtime,clock=host -boot menu=on"
start "QEMU" %QEMUDIR%\%QEMUBIN% -hda %VDRIVE% -name %NAME% -m %MEM% %CPUCORES% %OPTIONS%

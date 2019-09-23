@echo off
set "QEMUDIR=C:\PROGRA~1\qemu"
set "NAME=%1"
set "SIZE=%2"

if not exist %NAME%.img (
    %QEMUDIR%\qemu-img.exe create -f qcow2 -o size=%SIZE%G %NAME%.img
) else (
    echo file %NAME%.img already exist. Delete or move and try again.
    goto:eof
)

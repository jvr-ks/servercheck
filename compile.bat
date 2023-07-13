@rem compile.bat

@echo off

@call servercheck.exe remove
@call servercheck32.exe remove

@call "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in servercheck.ahk /out servercheck.exe /icon servercheck.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin"

@call "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in servercheck.ahk /out servercheck32.exe /icon servercheck.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 32-bit.bin"




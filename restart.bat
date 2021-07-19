@rem restart.bat
@rem !file is overwritten by update process!

@cd %~dp0


@echo No news available!
@echo.
@echo Please press a key to restart servercheck (%1 bit)!
@echo.
@pause

@echo off

@set version=%1
@if [%1]==[64] set version=

@if [%2]==[noupdate] goto noupdate

@copy /Y servercheck.exe.tmp servercheck%version%.exe

:noupdate
@del servercheck.exe.tmp
@start servercheck%version%.exe

:end
@exit
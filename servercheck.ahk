/*
 *********************************************************************************
 * 
 * servercheck.ahk
 * 
 * all files are UTF-8 no BOM encoded
 * 
 * Version -> appVersion
 * 
 * Copyright (c) 2021 jvr.de. All rights reserved.
 *
 * Licens -> Licenses.txt
 * 
 *********************************************************************************
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force

Loop % A_Args.Length()
{
	if(eq(A_Args[A_index],"remove"))
		exit()
}

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

FileEncoding, UTF-8-RAW
SetTitleMatchMode, 2

wrkDir := A_ScriptDir . "\"

bit := (A_PtrSize=8 ? "64" : "32")

if (!A_IsUnicode)
	bit := "A" . bit

bitName := (bit="64" ? "" : bit)

appName := "Servercheck"
appnameLower := "servercheck"
extension := ".exe"
appVersion := "0.008"
app := appName . " " . appVersion . " " . bit . "-bit"

;iniFile := wrkDir . "servercheck.ini"
urlsFile := wrkDir . "servercheck.txt"

server := "https://github.com/jvr-ks/" . appnameLower . "/raw/master/"

downLoadURL := server . appnameLower . bitName . extension

exeFilename := appnameLower . bitName . extension

downLoadFilename := appnameLower . ".exe.tmp"

restartFilename := "restart.bat"

downLoadURLrestart := server . restartFilename

urlsArr := []
selectedServer := ""

readServerUrls()
mainWindow()

return

;-------------------------------- mainWindow --------------------------------
mainWindow() {
	global app
	global appName
	global appVersion	

	global bit
	global hMain
	global urlsArr
	global LV1
	global Text1
	
	Menu, Tray, UseErrorLevel   ; This affects all menus, not just the tray.
	
	Menu, MainMenu,Add,Ping,ping
	Menu, MainMenu,Add,Traceroute,traceroute
	Menu, MainMenu,Add,Edit Servernames,editUrlsFile
	Menu, MainMenu,Add,Update,updateApp
	Menu, MainMenu,Add,Exit,exit
	
	Gui,guiMain:New, +OwnDialogs +LastFound -MaximizeBox HwndhMain, %app%

	Gui, Margin,6,4
	Gui, guiMain:Font, s10, Calibra

	lv1Width := 500
	
	fsDelta1 := 200
	fsDeltaFixed := 15

	Gui, guiMain:Add, ListView, x5 yp+25 w%lv1Width% gLVCommands vLV1 hwndhLV1 Grid AltSubmit -WantF2, |Server
	Gui, guiMain:Add, Text,w400 r20 x5 y150 vText1
	
	for index, url in urlsArr
	{
		row := LV_Add("",index,url)
	}
	
	LV_ModifyCol(1,"AutoHdr Integer")
	LV_ModifyCol(2,"AutoHdr Text")

	Menu, MainMenu, Add, Exit, exit
	Gui, guiMain:Menu, MainMenu
	
	Gui, guiMain:Add, StatusBar, 0x800 hWndhMySB
	
	showMessageServercheck("", "")

	Gui, guiMain:Show, autosize center
	
	return
}
;-------------------------------- LVCommands --------------------------------
LVCommands(){
	global selectedServer
	global urlsArr
		
	if (A_GuiEvent = "Normal"){
		selectedServer := urlsArr[A_EventInfo] 
	}

	return
}

;------------------------------- readServerUL -------------------------------
readServerUrls(){
	global urlsFile
	global urlsArr

	urlsArr := []

	Loop, read, %urlsFile%
	{
		if (A_LoopReadLine != "") {
			urlsArr.Push(A_LoopReadLine)
		}
	}
	
	return
}

;-------------------------- showMessageServercheck --------------------------
showMessageServercheck(hk1, hk2){

	SB_SetParts(160,580)
	SB_SetText(" " . hk1 , 1, 1)
	SB_SetText(" " . hk2 , 2, 1)

	memory := "[" . GetProcessMemoryUsage(DllCall("GetCurrentProcessId")) . " MB]      "
	SB_SetText("`t`t" . memory , 3, 2)

	return
}
;-------------------------------- restartApp --------------------------------
restartApp(){
	global bit
	global bitName
	global appnameLower
	global restartFilename
	
	msgbox, A restart of %appnameLower%%bitName% is required!
	run,%comspec% /k %restartFilename% %bit%
	
	exit()
}
;---------------------------- restartAppNoupdate ----------------------------
restartAppNoupdate(){
	global bit
	global bitName
	global appnameLower
	global restartFilename
	
	msgbox, A restart of %appnameLower%%bitName% is required!
	run,%comspec% /k %restartFilename% %bit% noupdate
	
	exit()
}
;--------------------------------- updateApp ---------------------------------
updateApp(){
	global appName
	global bitName
	global appVersion
	global downLoadFilename
	global restartFilename
	global downLoadURL
	global downLoadURLrestart

	vers := getVersionFromGithub()
	if (vers != "unknown"){
		if (vers > appVersion){
			msg := "This is: " . appVersion . ", available on Github is: " . vers . " update now?"
			MsgBox , 1, Update available!, %msg%
			
			IfMsgBox, OK
				{
					;restartXX.bat can contain update hints, allways download!
					
					UrlDownloadToFile, %downLoadURLrestart%, %restartFilename%
					sleep,1000
					
					UrlDownloadToFile, %downLoadURL%, %downLoadFilename%
							
					if FileExist(downLoadFilename){
						showHint(appName . bitName . " restarts now!",4000)
						restartApp()
						exitApp
					} else {
						msgbox,Could not download update!
					}
				}
		} else {
			msgbox, This version: %appVersion%, available version %vers%, no update available!
		}
	}
	return
}
;----------------------------------- ping -----------------------------------
ping(){
	global selectedServer
	global Text1
	
	if (selectedServer != ""){
		GuiControl,guiMain:,Text1,Ping started (result is  copied to the clipboard too) ...
		Runwait %comspec% /c ping %selectedServer% | clip,,hide
		s := clipboard
		GuiControl,guiMain:,Text1,%s%
	} else {
		msgbox, Select a server first!
	}

	return
}
;-------------------------------- traceroute --------------------------------
traceroute(){
	global selectedServer
	global Text1
	
	if (selectedServer != ""){
		GuiControl,guiMain:,Text1,Traceroute started, takes some time to finish (result is  copied to the clipboard too) ...
		Runwait %comspec% /c tracert %selectedServer% | clip,,hide
		s := clipboard
		GuiControl,guiMain:,Text1,%s%
	} else {
		msgbox, Select a server first!
	}

	return
}


;--------------------------- GetProcessMemoryUsage ---------------------------
GetProcessMemoryUsage(ProcessID)
{
	static PMC_EX, size := NumPut(VarSetCapacity(PMC_EX, 8 + A_PtrSize * 9, 0), PMC_EX, "uint")

	if (hProcess := DllCall("OpenProcess", "uint", 0x1000, "int", 0, "uint", ProcessID)) {
		if !(DllCall("GetProcessMemoryInfo", "ptr", hProcess, "ptr", &PMC_EX, "uint", size))
			if !(DllCall("psapi\GetProcessMemoryInfo", "ptr", hProcess, "ptr", &PMC_EX, "uint", size))
				return (ErrorLevel := 2) & 0, DllCall("CloseHandle", "ptr", hProcess)
		DllCall("CloseHandle", "ptr", hProcess)
		return Round(NumGet(PMC_EX, 8 + A_PtrSize * 8, "uptr") / 1024**2, 2)
	}
	return (ErrorLevel := 1) & 0
}
;--------------------------- getVersionFromGithub ---------------------------
getVersionFromGithub(){
	global appName

	r := "unknown!"
	StringLower, name, appName
	url := "https://github.com/jvr-ks/" . name . "/raw/master/version.txt"
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	Try
	{
		whr.Open("GET", url)
		whr.Send()
		Sleep 500
		status := whr.Status
		if (status == 200)
			r := whr.ResponseText
	}
	catch e
	{
		msgbox, Connection to %url% failed! [Error: %e%]
	}

	return r
}
;-------------------------- checkVersionFromGithub --------------------------
checkVersionFromGithub(){
	global appVersion
	global msgDefault
	global MainStatusBarHwnd
	
	ret := false
	
	vers := getVersionFromGithub()
	if (vers != "unknown"){
		if (vers > appVersion){
			msg := "New version available, this is: " . appVersion . ", available on Github is: " . vers
			SB_SetParts()
			SB_SetText(" " . msg , 1, 1)
			SendMessage, 0x2001, 0, 0x9999FF,, ahk_id %MainStatusBarHwnd%
			SendMessage, 0x0133, 0, 0xFFFFFF,, ahk_id %MainStatusBarHwnd%
			ret := true
		}
	}
	
	return ret
}

;------------------------------- editUrlsFile -------------------------------
editUrlsFile() {
	global urlsFile
	
	f := "notepad.exe" . " " . urlsFile
	showMessageServercheck("", "Please close the editor to refresh the menu!")
	runWait %f%,,max
	showMessageServercheck("", "")
	
	refreshGui()
}
;-------------------------------- refreshGui --------------------------------
refreshGui(){
	global urlsArr
	global selectedServer

	urlsArr := []
	selectedServer := ""

	readServerUrls()

	LV_Delete()
	
	for index, url in urlsArr
	{
		row := LV_Add("",index,url)
	}
	
	return
}
;------------------------------------ eq ------------------------------------
eq(a, b) {
	if (InStr(a, b) && InStr(b, a))
		return 1
	return 0
}
;--------------------------------- showHint ---------------------------------
showHint(s, n){
	global hinttimer
	global font
	global fontsize
	
	Gui, hint:Font, %fontsize%, %font%
	Gui, hint:Add, Text,, %s%
	Gui, hint:-Caption
	Gui, hint:+ToolWindow
	Gui, hint:+AlwaysOnTop
	Gui, hint:Show
	t := -1 * n
	setTimer,showHintDestroy, %t%
	return
}
;------------------------------ showHintDestroy ------------------------------
showHintDestroy(){
	global hinttimer

	setTimer,showHintDestroy, delete
	Gui, hint:Destroy
	return
}
;----------------------------------- exit -----------------------------------
exit(){
	ExitApp
}
;----------------------------------------------------------------------------

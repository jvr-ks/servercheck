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

bitName := (bit="64" ? "" : bit)

appName := "Servercheck"
appnameLower := "servercheck"
extension := ".exe"
appVersion := "0.016"
app := appName . " " . appVersion . " " . bit . "-bit"

urlsFile := wrkDir . "servercheck.txt"

server := "https://github.com/jvr-ks/" . appnameLower . "/raw/main/"

exeFilename := appnameLower . bitName . extension

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
  
  Menu, MainMenu,Add,NSLookup,NSLookup
  Menu, MainMenu,Add,Ping,ping
  Menu, MainMenu,Add,Traceroute,traceroute
  
  Menu, MainMenu,Add,Server,editUrlsFile
  Menu, MainMenu,Add,Update-check,updateApp
  Menu, MainMenu,Add,Github,openGithubPage
  Menu, MainMenu,Add,Exit,exit
  
  Gui,guiMain:New, +OwnDialogs +LastFound -MaximizeBox HwndhMain, %app%

  Gui, Margin,6,4
  Gui, guiMain:Font, s10, Segoe UI

  lv1Width := 500
  lv1Height := 200
  editHeight := lv1Height + 30
  
  Gui, guiMain:Add, ListView, x5 y5 h%lv1Height% w%lv1Width% gLVCommands vLV1 hwndhLV1 Grid AltSubmit -Multi NoSortHdr -LV0x10, |Server
  Gui, guiMain:Add, Edit, x5 r20 w%lv1Width% y%editHeight% vText1
  
  for index, url in urlsArr
  {
    row := LV_Add("",index,url)
  }
  
  LV_ModifyCol(1,"AutoHdr Integer")
  LV_ModifyCol(2,"AutoHdr Text")
  

  Menu, MainMenu, Add, Exit, exit
  Gui, guiMain:Menu, MainMenu
  
  Gui, guiMain:Add, StatusBar, 0x800 hWndhMySB
  
  Gui, guiMain:Show, autosize center
  
  showStatus("")
  
  return
}
;------------------------------ guiMainGuiClose ------------------------------
guiMainGuiClose(){
  exit()

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
;-------------------------------- showStatus --------------------------------
showStatus(s){

  SB_SetParts(200)
  SB_SetText(" " . s , 1, 1)

  memory := "[" . GetProcessMemoryUsage(DllCall("GetCurrentProcessId")) . " MB]      "
  SB_SetText("`t`t" . memory , 2, 2)

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
  global appnameLower

  r := "unknown!"
  url := "https://github.com/jvr-ks/" . appnameLower . "/raw/main/version.txt"
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
      openGithubDownloadPage()
      ret := true
    }
  }
  
  return ret
}
;--------------------------------- updateApp ---------------------------------
updateApp(){
  global appName
  global bitName
  global appVersion

  vers := getVersionFromGithub()
  if (vers != "unknown"){
    if (vers > appVersion){
      msg := "This is: " . appVersion . ", available on Github is: " . vers . " update now?"
      MsgBox , 1, Update available!, %msg%
      
      IfMsgBox, OK
        {
          openGithubDownloadPage()
          exitApp
        }
    } else {
      msgbox, This version: %appVersion%, available version %vers%, no update available!
    }
  }
  return
}
;------------------------------ openGithubPage ------------------------------
openGithubPage(){
  global appnameLower
  
  Run https://github.com/jvr-ks/%appnameLower%
  
  return
}
;-------------------------- openGithubDownloadPage --------------------------
openGithubDownloadPage(){
  global appnameLower
  
  Run https://github.com/jvr-ks/%appnameLower%/raw/main/%appnameLower%.exe

  return
}
;------------------------------- editUrlsFile -------------------------------
editUrlsFile() {
  global urlsFile
  
  f := "notepad.exe" . " " . urlsFile
  showStatus("Please close the editor!")
  runWait %f%,,max
  
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
  
  showStatus("")
  
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
;-------------------------------- runCommand --------------------------------
runCommand(selectedCommand){
  global selectedServer

  foundUnhidden := RegExMatch(selectedServer,"Oi)(\[unhidden])", match, 1)
  foundAutoclose := RegExMatch(selectedServer,"Oi)(\[autoclose])", match, 1)
  
  selectedServer := modifyServer(selectedServer)
  
  GuiControl,guiMain:,Text1,
    

  GuiControl,guiMain:,Text1,Executing may take a while`,`n`nplease be patient ...
  showstatus("Run command: " . selectedCommand . " " . selectedServer)
  
  consoleModifier := "/k"
  if (foundAutoclose)
    consoleModifier := "/c"
  
  result := ""
  if (foundUnhidden){
    GuiControl,guiMain:,Text1,Using a console window!
    runwait, %comspec% %consoleModifier% %selectedCommand% %selectedServer%
    GuiControl,guiMain:,Text1,
  } else {
    runwait, %comspec% /c %selectedCommand% %selectedServer% | clip,,hide
    result := clipboard
    GuiControl,guiMain:,Text1,%result%
    showstatus("Result is copied to the clipboard!")
  }

  return
}
;------------------------------- modifyCommand -------------------------------
modifyServer(s){

  locale := getLocale()

  s := StrReplace(s, "[locale]", locale)

  s := RegExReplace(s, "\[.*?]", "")
  
  return s
}
;--------------------------------- getLocale ---------------------------------
getLocale() {
  RegRead, theLocale, HKEY_CURRENT_USER\Control Panel\International, LocaleName
  
  return theLocale
}
;----------------------------------- ping -----------------------------------
ping(){
  runCommand("ping")
  return
}
;-------------------------------- traceroute --------------------------------
traceroute(){
  runCommand("tracert")
  return
}
;--------------------------------- NSLookup ---------------------------------
NSLookup() {
  runCommand("NSLookup.exe")
  return
}

;----------------------------------- exit -----------------------------------
exit(){
  ExitApp
}
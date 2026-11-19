#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode("Mouse", "Screen")

global SEB := "SafeExamBrowser.Client.exe"
global TOP_STRIP := 45   ; px from the top of the SEB window

; 1) Remove minimize/maximize boxes (your working method)
SetTimer(RemoveBoxes, 500)
RemoveBoxes() {
    for hwnd in WinGetList("ahk_exe " SEB)
        try WinSetStyle("-0x30000", "ahk_id " hwnd)
}

; 2) Restore instantly whenever a SEB window is minimised
cb := CallbackCreate(OnMinimize, "F", 7)
DllCall("SetWinEventHook", "UInt", 0x16, "UInt", 0x16, "Ptr", 0, "Ptr", cb, "UInt", 0, "UInt", 0, "UInt", 0)

OnMinimize(hHook, event, hwnd, idObj, idChild, thread, time) {
    if idObj != 0
        return
    SetTimer(() => RestoreIfSEB(hwnd), -1)
}
RestoreIfSEB(hwnd) {
    try if WinGetProcessName(hwnd) = SEB
        WinRestore("ahk_id " hwnd)
}

; 3) Swallow every click/tap in the top strip of the SEB window
InTopStrip() {
    MouseGetPos(&x, &y, &hwnd)
    if !hwnd || WinGetProcessName(hwnd) != SEB
        return false
    WinGetPos(, &wy, , , "ahk_id " hwnd)
    return y >= wy && y <= wy + TOP_STRIP
}

#HotIf InTopStrip()
$LButton::return
$LButton Up::return
$RButton::return
$RButton Up::return
#HotIf
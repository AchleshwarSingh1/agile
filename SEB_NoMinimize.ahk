
#Requires AutoHotkey v2.0
#SingleInstance Force

SetTimer(DisableWindowControls, 500)

DisableWindowControls() {
    windows := WinGetList("ahk_exe SafeExamBrowser.Client.exe")

    for hwnd in windows {
        try {
            ; Remove Minimize and Maximize window styles
            WinSetStyle("-0x30000", "ahk_id " hwnd)
        }
    }
}

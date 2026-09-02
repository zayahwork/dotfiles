#Requires AutoHotkey v2.0
#SingleInstance Force

; No-mouse layer for a 60% keyboard.
;
; Every hotkey writes a line to the log below, so a failure can be diagnosed by
; reading the file instead of guessing.
LOGFILE := A_Temp "\ahk_nomouse.log"

Log(msg) {
    global LOGFILE
    try FileAppend(FormatTime(, "HH:mm:ss") "  " msg "`n", LOGFILE)
}

Log("=== script loaded ===")

; ------------------------------------------------------------- the arrow layer
; Caps Lock is the layer key. Using it as a hotkey prefix suppresses its normal
; toggle, so it never turns caps on again. Tapped alone it sends F12.
;
;   RAlt + h j k l    left, down, up, right
;   RAlt + u / o      page up / page down
;   RAlt + i / p      home / end
;   RAlt + n          delete forward

CapsLock & h::{
    Log("Caps+h -> Left")
    Send("{Left}")
}
CapsLock & j::{
    Log("Caps+j -> Down")
    Send("{Down}")
}
CapsLock & k::{
    Log("Caps+k -> Up")
    Send("{Up}")
}
CapsLock & l::{
    Log("Caps+l -> Right")
    Send("{Right}")
}
CapsLock & u::{
    Log("Caps+u -> PgUp")
    Send("{PgUp}")
}
CapsLock & o::{
    Log("Caps+o -> PgDn")
    Send("{PgDn}")
}
CapsLock & i::{
    Log("Caps+i -> Home")
    Send("{Home}")
}
CapsLock & p::{
    Log("Caps+p -> End")
    Send("{End}")
}
CapsLock::{
    Log("Caps tap -> F12")
    Send("{F12}")
}

CapsLock & n::{
    Log("Caps+n -> Delete")
    Send("{Delete}")
}

; ---------------------------------------------------------------- scrolling --
; A wheel event goes to whatever is under the mouse pointer, not to the focused
; window. So park the pointer over the middle of the active window, send the
; wheel, then put the pointer back. The move is instant and invisible.

ScrollActiveWindow(notches, direction) {
    hwnd := WinExist("A")
    if !hwnd {
        Log("scroll: no active window")
        return
    }

    try WinGetPos(&x, &y, &w, &h, hwnd)
    catch {
        Log("scroll: WinGetPos failed")
        return
    }

    if (w < 50 || h < 50) {
        Log("scroll: window too small")
        return
    }

    MouseGetPos(&startX, &startY)
    DllCall("SetCursorPos", "int", x + (w // 2), "int", y + (h // 2))

    if (direction = "down")
        Send("{WheelDown " notches "}")
    else
        Send("{WheelUp " notches "}")

    DllCall("SetCursorPos", "int", startX, "int", startY)
    Log("scroll " direction " " notches)
}

^+j::ScrollActiveWindow(3, "down")
^+k::ScrollActiveWindow(3, "up")
^+d::ScrollActiveWindow(10, "down")
^+u::ScrollActiveWindow(10, "up")

; ---------------------------------------------------------------- kill switch
; If anything about this script ever misbehaves, this stops it dead and hands
; the keyboard straight back to Windows.

^!+q::{
    Log("=== killed by hotkey ===")
    ExitApp()
}



; ------------------------------------------------------- focus the chat input
; Tab cycles through every focusable element in an Electron app, which is why it
; lands on random things. This puts the caret straight in the text box instead:
; click low and left of center in the active window, where a chat composer sits,
; then put the mouse pointer back where it was.

FocusChatBox() {
    ; Jump to the Claude window from anywhere, then put the caret in its
    ; composer. The old version clicked inside whatever window was focused,
    ; which meant pressing this from a terminal clicked in the terminal.
    if !WinExist("ahk_exe Claude.exe") {
        Log("focus: Claude window not found")
        return
    }

    WinActivate("ahk_exe Claude.exe")
    if !WinWaitActive("ahk_exe Claude.exe", , 2) {
        Log("focus: Claude did not come to the front")
        return
    }

    try WinGetPos(&x, &y, &w, &h, "ahk_exe Claude.exe")
    catch {
        Log("focus: WinGetPos failed")
        return
    }

    MouseGetPos(&startX, &startY)
    targetX := x + Round(w * 0.55)
    targetY := y + h - 60

    DllCall("SetCursorPos", "int", targetX, "int", targetY)
    Click()
    DllCall("SetCursorPos", "int", startX, "int", startY)

    Log("focus Claude composer at " targetX "," targetY " window " x "," y " " w "x" h)
}
^!Enter::FocusChatBox()

; ------------------------------------------------- calibrate the chat box spot
; Hover the mouse over the chat input once and press this. It records where the
; pointer is relative to the window, so FocusChatBox can hit the same place from
; then on without the mouse.

^!+p::{
    hwnd := WinExist("A")
    if !hwnd
        return
    try WinGetPos(&x, &y, &w, &h, hwnd)
    catch
        return
    MouseGetPos(&mx, &my)
    fx := Round((mx - x) / w, 4)
    fy := Round((my - y) / h, 4)
    Log("CALIBRATE mouse=" mx "," my "  window=" x "," y " " w "x" h "  fraction=" fx "," fy)
}

; --------------------------------------------------- the mouse, on the keyboard
; Hold Caps and use w a s d to move the pointer. Holding a key repeats, so it
; glides. Add Shift for fine, one-pixel-ish steps when you need to land exactly.
;
;   Caps + w a s d          move pointer up left down right
;   Caps + shift + w a s d  same, but slow and precise
;   Caps + space            left click
;   Caps + e                right click
;   Caps + q                middle click
;   Caps + z                click and hold, press again to release

MouseStep() {
    return GetKeyState("Shift", "P") ? 4 : 28
}

MovePointer(dx, dy) {
    step := MouseStep()
    MouseGetPos(&mx, &my)
    DllCall("SetCursorPos", "int", mx + (dx * step), "int", my + (dy * step))
}

CapsLock & w::MovePointer(0, -1)
CapsLock & s::MovePointer(0, 1)
CapsLock & a::MovePointer(-1, 0)
CapsLock & d::MovePointer(1, 0)

CapsLock & Space::{
    Log("Caps+Space -> left click")
    Click()
}
CapsLock & e::{
    Log("Caps+e -> right click")
    Click("Right")
}
CapsLock & q::{
    Log("Caps+q -> middle click")
    Click("Middle")
}

global DRAGGING := false
CapsLock & z::{
    global DRAGGING
    if DRAGGING {
        Click("Up")
        DRAGGING := false
        Log("drag released")
    } else {
        Click("Down")
        DRAGGING := true
        Log("drag started")
    }
}


; ------------------------------------------------------------ app hotkeys --
; These used to live on Desktop shortcut Hotkey properties, which Explorer
; handles unreliably when the Desktop is redirected into OneDrive. AutoHotkey
; is already running and its hotkeys are proven to fire, so it owns them now.
;
;   Ctrl+Alt+G  WezTerm, which opens straight into herdr
;   Ctrl+Alt+C  the Claude app
;   Ctrl+Alt+A  the four pane Windows Terminal layout

RaiseOrLaunch(winTitle, exePath, args := "") {
    if WinExist(winTitle) {
        WinActivate(winTitle)
        Log("raised " winTitle)
        return
    }
    try {
        if (args = "")
            Run(exePath)
        else
            Run(exePath " " args)
        Log("launched " exePath)
    } catch as e {
        Log("launch failed: " exePath " - " e.Message)
    }
}

^!g::RaiseOrLaunch("ahk_exe wezterm-gui.exe", '"C:\Program Files\WezTerm\wezterm-gui.exe"')
^!c::RaiseOrLaunch("ahk_exe Claude.exe", 'explorer.exe', 'shell:AppsFolder\Claude_pzs8sxrjxfjjc!Claude')
^!a::{
    Log("agents layout")
    Run('powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Corp-builder\agents.ps1"')
}

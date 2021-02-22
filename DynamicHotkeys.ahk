#NoEnv
#SingleInstance, Force
#NoTrayIcon


EXTRA_KEY_LIST := "{Esc}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}{Media_Play_Pause}{Enter}{Tab}"
 
SingleKey := ""
 
ModifierState := {}
lasthk1 := ""

Gui, +ToolWindow
gui, font,, Helvetica
gui, color, 33333
gui, color,, 33333

Gui, Add, Button, gBind vHotkeyName  w120, KLIKNIJ 

Gui, Show, Center w300, DyanmicHotkeys By jedziemy
return

Save: 
{
        gui, submit, NoHide
}
Return

guiclose:
	ExitApp
 
Bind:
Bind()
return



Bind(){
global ModifierState
global BindMode
global EXTRA_KEY_LIST
global lasthk
global found
 
found := 0
ModifierState := {ctrl: 0, alt: 0, shift: 0, win: 0, lbutton: 0, rbutton: 0, space: 0}
Gui, 2:Add, text, center, Kliknij wybrany przez ciebie przycisk. Przyciski Ctrl, Alt, Shift, XButton2, XButton1, Win, itp. tez sa zapisywane!`n`n`n [Kliknij ESC aby anulowac]
Gui, 2:-Border +AlwaysOnTop
Gui, 2:Show
 
BindMode := 1
Loop {
Input, SingleKey, L1 M T0.1, %EXTRA_KEY_LIST%
if (ErrorLevel == "Max" ) {
found := SingleKey
} else if (substr(ErrorLevel,1,7) == "EndKey:"){
tmp := substr(ErrorLevel,8)
if (tmp == "Escape"){
break
}
found := tmp
}
if (found){
break
}
}
BindMode := 0
Gui, 2:Submit
if (found){
outstring := ""
outhk := ""
; List modifiers in a specific order
modifiers := ["ctrl","alt","shift","win", "lbutton", "rbutton", "space"]
 
Loop, 4 {
key := modifiers[A_Index]
value := ModifierState[modifiers[A_Index]]
if (value){
if (outstring != ""){
outstring .= " + "
}
stringupper, tmp, key
outstring .= tmp
 
if (key == "ctrl"){
        outhk .= "^"
        } else if (key == "alt") {
        outhk .= "!"
        } else if (key == "shift") {
            outhk .= "+"
        } else if (key == "win") {
            outhk .= "#"
        } else if (key == "LButton") {
            outhk .= "L"    
        } else if (key == "RButton") {
            outhk .= "R"
        } else if (key == "space") {
            outhk .= "*"
         }
    }
}
if (outstring != ""){
outstring .= " + "
}
outhk .= found
StringUpper, found, found
outstring .= found
 
if (lasthk != ""){
hotkey, ~*%lasthk%, Off
}
lasthk := outhk
hotkey, ~*%lasthk%, DoHotkey
 
GuiControl,, HotkeyName, %outstring%
;msgbox % "Hotkey Detected.`n`nHuman-Readable: " outstring "`nAHK Hotkey string: " outhk
}
return
}



DoHotkey:
return



; Detects Modifiers in BindMode
#If BindMode
*lctrl::
*rctrl::
*lalt::
*ralt::
*lshift::
*rshift::
*lwin::
*rwin::
*space::
mod := substr(A_ThisHotkey,2)
SetModifier(mod,1)
return
 
*lctrl up::
*rctrl up::
*lalt up::
*ralt up::
*lshift up::
*rshift up::
*lwin up::
*rwin up::
mod := substr(substr(A_ThisHotkey,2),1,strlen(A_ThisHotkey) -4)
SetModifier(mod,0)
if (!ModifierCount()){

;if other modifiers still held, do not set found
found := mod
}
return
 
lbutton::
rbutton::
mbutton::
xbutton1::
xbutton2::
wheelup::
wheeldown::
wheelleft::
wheelright::

found := A_ThisHotkey
return
 
#If
 
; Sets the state of the ModifierState object to reflect the state of the modifier keys
SetModifier(hk,state){
global ModifierState
 
if (hk == "lctrl" || hk == "rctrl"){
    ModifierState.ctrl := state
} else if (hk == "lalt" || hk == "ralt"){
    ModifierState.alt := state
} else if (hk == "lshift" || hk == "rshift"){
    ModifierState.shift := state
} else if (hk == "lwin" || hk == "rwin"){
    ModifierState.win := state
} else if (hk == "lbutton") {
    ModifierState.LButton := state
} else if (hk == "rbutton") {
    ModifierState.RButton := state
} else if (hk == "space") {
    ModifierState.space := state
	}
}
return

 
; Counts how many modifier keys are held
ModifierCount() {
global ModifierState
 
return ModifierState.ctrl  + ModifierState.alt  + ModifierState.shift  + ModifierState.win  + ModifierState.Lbutton  + ModifierState.Rbutton  + ModifierState.space
}
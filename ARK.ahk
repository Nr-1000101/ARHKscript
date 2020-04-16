; Author Nr. 69
; Under GNU General Public License v3.0
; Latest updates at https://github.com/Nr69/ARHKscript

;---------------------------------------------------------------------------------------------------------------

; COORDINATE AND CONSTANT INITIALIZATION
; Everything was done for 1920, 1080 resolution and my own needs so If you have different setup edit them as needed (WindowSpy.ahk can help you with this task)

; Various coordinates X, Y
; 1 Center 960, 540
; 2 Personal inventory search 210, 180
; 3-7 Inventory first 5 slots 170, 280; 260, 280; 350, 280; 440, 280; 540, 280
; 8 Foreign inventory search 1340, 180
; 9 Foreign inventory first slot 1290, 280
; 10 Terminal creatures 1540, 110
; 11 First creature to upload 1500, 260
; 12 First creature to download 1500, 650
; 13 Upload 1750, 180
; 14 Download 1750, 580
; 15 Accept 800, 600
; 16 Hp level up 1150, 510
; 17 Dmg level up 1150, 730
; 18 S+ resources request in foreign inventory 1230, 40
; 19 S+ resources request clear search 730 210
; 20 S+ resources request search 600, 210
; 21 S+ resources request first option 620, 250
; 22 S+ resources request first storage resource amount 1250, 250
; 23 S+ resources request pull 730, 870
; 24 S+ resources request done 1200, 870
; 25 Turn On structure 930, 620
; 26 Dino options 700, 400
; 27 Dino change name 1100, 430
; 28 Dino behaviour 820, 810
; 29 Dino disable wandering 1110, 480
; 30 Dino enter name space 960, 430
; 31 S+ amount of something to craft bar 1300, 30
; 32 S+ draw the resources to craft the said amount icon 1380, 30

coords := [{"x":960,"y":540}, {"x":210,"y":180}, {"x":170,"y":280}, {"x":260,"y":280}, {"x":350,"y":280}, {"x":440,"y":280}, {"x":540,"y":280}, {"x":1340,"y":180}, {"x":1290,"y":280}
,{"x":1540,"y":110}, {"x":1500,"y":260}, {"x":1500,"y":650}, {"x":1750,"y":180}, {"x":1750,"y":580}, {"x":800,"y":600}, {"x":1150,"y":510}, {"x":1150,"y":730}, {"x":1230,"y":40}
,{"x":730,"y":210}, {"x":600,"y":210}, {"x":620,"y":250}, {"x":1250,"y":250}, {"x":730,"y":870}, {"x":1200,"y":870}, {"x":930,"y":620}, {"x":700,"y":400}, {"x":1100,"y":430}, {"x":820,"y":810}
,{"x":1110,"y":480}, {"x":960,"y":430}, {"x":1300,"y":30}, {"x":1380,"y":30}]

; Other
; 1 Upload/download dinos en masse 5 at a time
; 2 Number of chemistry benches 10
; 3 Number of fabricators 4
; 4 Gap between chemistry benches in ms (how long to hold the movement button) 250
; 5 Gap between fabricators in ms (how long to hold the movement button) 310
; 6 Max level ups for dino 73
; 7 & 8 Levels into hp and into damage on hybrid leveling 10 and 63 respectively
; 9 Name for the dino 42
; 10 color id for turn on function 0xBFA840

consts := [5, 10, 4, 250, 310, 73, 10, 63, 42, 0xBFA840]

return

;---------------------------------------------------------------------------------------------------------------

; HOTKEYS

#maxThreadsPerHotkey, 2

; Quit the program if something malfunctions
NumpadEnter & NumpadSub::ExitApp ;


; Equip first leggings
*XButton2::SwapLeggings() ;

; Equip first 5 flak pieces 
*XButton1::SwapFullFlak() ;


; Self explanatory
NumpadEnter & Numpad1::AutoLeftClick() ;
NumpadEnter & Numpad4::PressAndHoldLeft() ;
NumpadEnter & Numpad2::AutoRightClick() ;
NumpadEnter & Numpad3::AutoESpam() ;

NumpadEnter & Numpad7::UploadXDinos() ;
NumpadEnter & Numpad9::DownloadXDinos() ;

; Cap the production of Spark Powder and Gun Powder on chem benches and Advanced Bifle Bullet on fabricators or replicators
; I used PixelSearch to determine whether the station is turned on. I noticed the color value changes with gamma so I recommend using the standard ARK gamma settings when running this
NumpadAdd & Numpad7::SPGP() ;
NumpadAdd & Numpad9::ARB() ;

; Quickly level soakers, gigas and etc.
NumpadAdd & Numpad4::PumpHpOnDino() ;
NumpadAdd & Numpad5::PumpDmgOnDino() ;
NumpadAdd & Numpad6::PumpHpAndDmgOnDino() ;

; Different dinos have slightly different option wheels sometimes so the coordinates of some options might be wrong and these won't work
NumpadSub & Numpad1::NameDinoAndDisableWandering() ;
NumpadSub & Numpad3::NeuterOrSpayDinoAndCryoIt() ;
;---------------------------------------------------------------------------------------------------------------

; FUNCTIONS

; Send and Sleep
SS(text, sleep:=50){ 
	Send, %text%
	Sleep, %sleep%
	return
}

; Send and Hold
SH(text, sleep:=50){ 
	Send, {%text% down}
	Sleep, %sleep%
	Send, {%text% up}
	return
}

; Click and Sleep
CS(c, sleep:=50){
	global coords
	x := coords[c].x
	y := coords[c].y
	Click, %x%, %y%
	Sleep, %sleep%
	return
}

; Personal Inventory Search
PIS(text){		
	CS("2")
	SS(text)	
	return
}

; Foreign Inventory Search
FIS(text){		
	CS("8")
	SS(text, "500")	
	return
}

; S+ Fetch Items
SFI(text, amount){		
	CS("19", "500")
	CS("20", "500")
	SS(text, "500")
    CS("21", "500")
	CS("22", "500")
	SS(amount, "500")
	CS("23", "1000")
	return
}

; S+ Draw resources to Craft X
SDCX(amount){		
	CS("31", "500")
	Send, {backspace}
	Sleep, 500
	SS(amount, "500")
    CS("32", "500")
	return
}

; Check if Bench is Turned on
CBT(){
	Global coords, consts
	x := coords[25].x
	y := coords[25].y
	c := consts[10]
	PixelSearch Px, Py, %x%, %y%, %x%, %y%, %c%, 3, Fast
	if (ErrorLevel = 0)
	{	
		CS("25")
	}
	return
}

SwapLeggings(){
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		BlockInput On
		SS("i", "200")
		PIS("leggings")
		CS("3")
		CS("3")
		SS("i")
        BlockInput Off
	}
	return
}

SwapFullFlak(){
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
		{
		BlockInput On
		SS("i", "200")
		PIS("flak")
		CS("7")
		CS("7")
		CS("6")
		CS("6")
		CS("5")
		CS("5")
		CS("4")
		CS("4")
		CS("3")
		CS("3")
		SS("i")
	    BlockInput Off
    }
	return
}

AutoESpam(){
	Global TES ; Toggle E Spam
	TES := !TES
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
     	Loop
     	{
     		If (!TES)
     			{
     			Break
     			}
			SS("e", "200")
		}
	}
	return
}

AutoLeftClick(){
	Global coords
	x := coords[1].x
	y := coords[1].y
	Global TALC ; Toggle Auto Left Click
	TALC := !TALC 
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
     	Loop
     	{
     		If (!TALC)
     			{
     			Break
     			}
			ControlClick, X%x% Y%y%, ARK: Survival Evolved
			Sleep, 500
		}
	}
	return
}

PressAndHoldLeft(){
	Global coords
	x := coords[1].x
	y := coords[1].y
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		Click, down, %x%, %y% 
	}
	return
}

AutoRightClick(){
	Global coords
	x := coords[1].x
	y := coords[1].y
	Global TARC ; Toggle Auto Right Click
	TARC := !TARC 
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
     	Loop
     	{
     		If (!TARC)
     			{
     			Break
     			}
			ControlClick, X%x% Y%y%, ARK: Survival Evolved, , RIGHT
			Sleep, 500
		}
	}
	return
}

UploadXDinos(){
	Global consts
	c := consts[1]
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		BlockInput On
		SS("f", "500")
		CS("10", "200")
		Loop, %c%
			{
			CS("11")
			CS("13")
			CS("15", "500")		
		    }
		SS("f")
	    BlockInput Off
    }
	return
}

DownloadXDinos(){
	Global consts
	c := consts[1]
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		BlockInput On
		SS("f", "500")
		CS("10", "200")
		Loop, %c%
			{
			CS("12", "800")
			CS("14", "200")	
		    }
		SS("f")
	    BlockInput Off
    }
	return
}

SPGP(){
	Global consts
	c := consts[2]
	t := consts[4]
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		BlockInput On
		Loop, %c%
			{
			SS("f", "1000")
			FIS("gunpowder")
			CS("9", "200")
			CS("18", "1000")
			SFI("gasoline", "1")
		    CS("24", "2000")
		    SDCX("1000")
			CBT()
			CS("9", "200")
			Loop, 10
				{
		    	SS("a", "100")
		    	}
		    CS("8")
			FIS("sparkpowder")
			CS("9", "200")
			CS("32", 500)					
			CS("9", "200")
			Loop, 10
				{
		    	SS("a", "100")
		    	}
			SS("f", "1000")
			SH("d", t)
		    }
	    BlockInput Off
    }
	return
}

ARB(){
	Global consts
	c := consts[3]
	t := consts[5]
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		BlockInput On
		Loop, %c%
			{
			SS("f", "1000")
			FIS("rifle bullet")
			CS("9", "200")
			SDCX("1000")
		    CBT()
			CS("9", "200")
			Loop, 10
				{
		    	SS("a", "100")
		    	}
			SS("f", "1000")
			SH("d", t)
		    }
	    BlockInput Off
    }
	return
}

PumpHpOnDino(){
	Global consts
	l := consts[6]
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		BlockInput On
		SS("f", "1000")
		Loop, %l%
			{
			CS("16", "20")
			}
		SS("f")
	    BlockInput Off
	}
	return
}

PumpDmgOnDino(){
	Global consts
	l := consts[6]
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		BlockInput On
		SS("f", "1000")
		Loop, %l%
			{
			CS("17", "20")
			}
		SS("f")
	    BlockInput Off
	}
	return
}

PumpHpAndDmgOnDino(){
	Global consts
	h := consts[7]
	d := consts[8]
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		BlockInput On
		SS("f", "1000")
		Loop, %h%
			{
			CS("16", "20")
			}
		Loop, %d%
			{
			CS("17", "20")
			}
		SS("f")
	    BlockInput Off
	}
	return
}

NameDinoAndDisableWandering(){
	Global consts
	n := consts[9]
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		BlockInput On
		Send, {e down}
		Sleep 1000
		CS("26", "200")
		CS("27")
		Send, {e up}
		CS("30")
		SS(n, "500")
		Send, {enter}
		Sleep, 50
		Send, {enter}
		Sleep, 1000
		Send, {e down}
		Sleep 1000
		CS("28", "500")
		CS("29", "500")
		Send, {e up}
	    BlockInput Off
	}
	return
}

NeuterOrSpayDinoAndCryoIt(){
	Global coords
	x := coords[26].x
	y := coords[26].y
	IfWinActive, ARK: Survival Evolved ahk_class UnrealWindow
	{
		BlockInput On
		Send, {e down}
		Sleep 1000
		CS("26", "200")
		MouseMove, %x%, %y%
		Sleep, 5000
		CS("26")
		Send, {e up}
		SS("i", "500")
		PIS("empty cryopod")
		CS("3", "200")
		SS("e", "200")
		SS("i", "2000")
		MouseClick, left
	    BlockInput Off
	}
	return
}

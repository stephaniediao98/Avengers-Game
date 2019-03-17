; #########################################################################
;
;   game.inc - Includes for EECS205 Assignment 4
;
;
; #########################################################################

;; Library Definitions
MouseInfo STRUCT
 horiz DWORD ?
 vert  DWORD ?
 buttons DWORD ?
MouseInfo ENDS		

MK_CONTROL  = 0008h  ;; The CTRL key is down.
MK_LBUTTON  = 0001h  ;; The left mouse button is down.
MK_MBUTTON  = 0010h  ;; The middle mouse button is down.
MK_RBUTTON  = 0002h  ;; The right mouse button is down.
MK_SHIFT    = 0004h  ;; The SHIFT key is down.
MK_XBUTTON1 = 0020h  ;; The first X button is down.
MK_XBUTTON2 = 0040h  ;; The second X button is down.

;; Library Functions
BlackStarField	PROTO
DrawStr PROTO myStr:PTR BYTE, x:DWORD, y:DWORD, color:DWORD

;; Library Data
EXTERNDEF StarBitmap:EECS205BITMAP
EXTERNDEF MouseStatus:MouseInfo
EXTERNDEF KeyUp:DWORD
EXTERNDEF KeyDown:DWORD
EXTERNDEF KeyPress:DWORD
EXTERNDEF ironman:EECS205BITMAP
EXTERNDEF thanos:EECS205BITMAP
EXTERNDEF gauntlet:EECS205BITMAP
EXTERNDEF red:EECS205BITMAP
EXTERNDEF orange:EECS205BITMAP
EXTERNDEF yellow:EECS205BITMAP
EXTERNDEF green:EECS205BITMAP
EXTERNDEF blue:EECS205BITMAP
EXTERNDEF purple:EECS205BITMAP
EXTERNDEF captainamerica:EECS205BITMAP
EXTERNDEF thor:EECS205BITMAP
EXTERNDEF spiderman:EECS205BITMAP
EXTERNDEF groot:EECS205BITMAP
EXTERNDEF antman:EECS205BITMAP

;; User Defined Functions
GameInit PROTO
GamePlay PROTO
CheckIntersect PROTO oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP 






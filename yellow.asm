; #########################################################################
;
;   yellow.asm - Assembly file for EECS205 Assignment 4/5
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc

;; Has keycodes
include keys.inc

.DATA

yellow EECS205BITMAP <35, 42, 255,, offset yellow + sizeof yellow>
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,024h,024h,024h,024h
	BYTE 024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,049h,092h
	BYTE 092h,092h,092h,049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h
	BYTE 024h,049h,0b6h,0b6h,0b6h,0b6h,049h,024h,020h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,024h,049h,06dh,0b5h,0d9h,0d9h,0d9h,0d9h,0b5h,06dh,069h,024h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,024h,08eh,0b6h,0dah,0fdh,0fdh,0fdh,0fdh,0dah,0b6h,092h,024h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,024h,049h,049h,0b5h,0dah,0d9h,0d8h,0d8h,0d8h,0d8h,0d9h
	BYTE 0dah,0b6h,049h,049h,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,049h,092h,0b6h,0fdh,0fdh,0b4h,06ch,06ch
	BYTE 06ch,06ch,0b4h,0fdh,0fdh,0b6h,092h,049h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,024h,06dh,0b6h,0b6h,0d9h,0fch
	BYTE 0b4h,06ch,06ch,06ch,06ch,0b4h,0fdh,0fdh,0b6h,0b6h,069h,024h,024h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,06dh,092h,0b5h,0fdh
	BYTE 0f9h,0b0h,090h,06ch,068h,048h,048h,048h,0b5h,0feh,0feh,0fdh,0fdh,0b5h,092h,06dh
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,06eh
	BYTE 0b6h,0dah,0fdh,0fch,090h,06ch,06ch,06ch,06ch,06ch,06ch,0b5h,0feh,0feh,0fdh,0fdh
	BYTE 0dah,0b6h,08eh,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h
	BYTE 069h,06dh,0b5h,0d9h,0d9h,0b4h,090h,06ch,06ch,090h,0b4h,0b4h,0b4h,0b4h,0d9h,0feh
	BYTE 0feh,0fdh,0fdh,0fdh,0d9h,0b5h,06dh,06dh,024h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,049h,092h,0b6h,0ddh,0fdh,0d8h,06ch,06ch,048h,048h,0b4h,0fch,0fch,0fch
	BYTE 0fch,0fdh,0feh,0feh,0feh,0feh,0fdh,0fdh,0fdh,0b6h,092h,049h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,049h,092h,0b6h,0fdh,0fdh,0d8h,06ch,06ch,090h,090h,0d8h
	BYTE 0fch,0fch,0fch,0fch,0fdh,0fdh,0fdh,0feh,0feh,0fdh,0fdh,0fdh,0b6h,092h,049h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,049h,092h,0b6h,0fdh,0fdh,0d8h,06ch,06ch
	BYTE 0d8h,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fdh,0feh,0feh,0fdh,0fdh,0fdh,0b6h
	BYTE 092h,049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,049h,092h,0b6h,0fdh,0fdh
	BYTE 0d8h,06ch,06ch,0d8h,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fdh,0feh,0feh,0fdh
	BYTE 0fdh,0fdh,0b6h,092h,049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,049h,092h
	BYTE 0b6h,0fdh,0fdh,0d8h,06ch,06ch,0d8h,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fdh
	BYTE 0feh,0feh,0fdh,0fdh,0fdh,0b6h,092h,049h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,049h,092h,0b6h,0fdh,0fdh,0d8h,06ch,06ch,0d8h,0fch,0fch,0fch,0fch,0fch,0fch
	BYTE 0fch,0fch,0fdh,0feh,0feh,0fdh,0fdh,0fdh,0b6h,092h,049h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,049h,092h,0b6h,0fdh,0fdh,0d8h,06ch,06ch,0d8h,0fch,0fch,0fch
	BYTE 0fch,0fch,0fch,0fch,0fch,0fdh,0feh,0feh,0fdh,0fdh,0fdh,0b6h,092h,049h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,049h,092h,0b6h,0fdh,0fdh,0d8h,06ch,06ch,0d8h
	BYTE 0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fdh,0feh,0feh,0fdh,0fdh,0fdh,0b6h,092h
	BYTE 049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,049h,092h,0b6h,0fdh,0fdh,0d8h
	BYTE 06ch,06ch,0d8h,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fdh,0feh,0feh,0fdh,0fdh
	BYTE 0fdh,0b6h,092h,049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,049h,092h,0b6h
	BYTE 0fdh,0fdh,0d8h,06ch,06ch,0d8h,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fdh,0feh
	BYTE 0feh,0fdh,0fdh,0fdh,0b6h,092h,049h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 049h,092h,0b6h,0ddh,0fdh,0d8h,06ch,06ch,0b4h,0b4h,0d8h,0fch,0fch,0fch,0fch,0fdh
	BYTE 0fdh,0fdh,0feh,0feh,0fdh,0fdh,0fdh,0b6h,092h,049h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,049h,092h,0b6h,0fdh,0fdh,0d8h,06ch,06ch,06ch,04ch,0b4h,0fch,0fch
	BYTE 0fch,0fch,0fdh,0feh,0feh,0feh,0feh,0fdh,0fdh,0fdh,0b6h,092h,049h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,024h,06eh,092h,0d9h,0fdh,0d9h,090h,06ch,06ch,048h
	BYTE 0b4h,0fdh,0fdh,0fdh,0fdh,0fdh,0feh,0feh,0feh,0feh,0fdh,0fdh,0d9h,092h,092h,025h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,024h,024h,092h,0b6h,0d9h,0fdh
	BYTE 0d8h,090h,06ch,0b5h,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0fdh,0fdh,0dah,0b6h,092h
	BYTE 024h,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,06dh
	BYTE 092h,0d6h,0fdh,0fdh,090h,06ch,0b5h,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0fdh,0fdh
	BYTE 0b6h,092h,06eh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,025h,049h,08dh,0d6h,0d9h,0b9h,0b8h,0d9h,0feh,0feh,0feh,0feh,0feh,0fdh
	BYTE 0fdh,0dah,0dah,08dh,049h,049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,049h,092h,0b6h,0fdh,0fdh,0fdh,0feh,0feh,0feh
	BYTE 0feh,0fdh,0fdh,0fdh,0b6h,092h,049h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,025h,06dh,091h,0d9h,0f9h,0fdh
	BYTE 0feh,0feh,0feh,0feh,0fdh,0fdh,0d9h,091h,06eh,025h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,024h
	BYTE 092h,0b6h,0dah,0fdh,0fdh,0fdh,0fdh,0dah,0b6h,092h,024h,024h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,024h,06dh,092h,0b5h,0fdh,0fdh,0fdh,0fdh,0b6h,092h,06eh,024h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,024h,024h,06dh,0b6h,0b6h,0b6h,0b6h,06dh,024h,024h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,049h,092h,092h,0b2h,092h
	BYTE 049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,049h
	BYTE 049h,049h,049h,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h

END

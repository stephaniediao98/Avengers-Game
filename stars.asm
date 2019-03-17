; #########################################################################
;
;   stars.asm - Assembly file for EECS205 Assignment 1
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive


include stars.inc

.DATA

	;; If you need to, you can place global variables here

.CODE

DrawStarField proc

	; draws a field of stars that will serve as the background 	  of the game
	; background: 640px x 480px
	; Invoke DrawStar x-coordinate, y-coordinate

	invoke DrawStar, 40, 400	;star 1
	invoke DrawStar, 10, 20	;star 2
	invoke DrawStar, 120, 200	;star 3
	invoke DrawStar, 200, 300	;star 4
	invoke DrawStar, 320, 460	;star 5
	invoke DrawStar, 300, 240	;star 6	
	invoke DrawStar, 340, 50	;star 7
	invoke DrawStar, 400, 100	;star 8	
	invoke DrawStar, 600, 10	;star 9
	invoke DrawStar, 500, 200	;star 10
	invoke DrawStar, 600, 460	;star 11	
	invoke DrawStar, 620, 20	;star 12
	invoke DrawStar, 560, 100	;star 13
	invoke DrawStar, 440, 350	;star 14
	invoke DrawStar, 220, 110	;star 15
	invoke DrawStar, 180, 180	;star 16

	ret  			; Careful! Don't remove this line
DrawStarField endp



END
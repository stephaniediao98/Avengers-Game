; #########################################################################
;
;   trig.asm - Assembly file for EECS205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include trig.inc
include blit.inc
include stars.inc
include lines.inc

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI 
TWO_PI	= 411774                ;;  2 * PI 
PI_INC_RECIP =  5340353        	;;  Use reciprocal to find the table entry for a given angle
	                        ;;              (It is easier to use than divison would be)


	;; If you need to, you can place global variables here
	
.CODE

FixedSin PROC USES edi ecx ebx esi angle:FXPT

	mov edi, angle
      mov ecx, PI
      mov ebx, TWO_PI

; EDGE CASE: angle < 0
less_than_0:
    cmp edi, 0
    jge greater_than_2pi
    add edi, TWO_PI
    jmp less_than_0

; EDGE CASE: angle > 2pi
greater_than_2pi:
    cmp edi, TWO_PI
    jl quadrant_1
    sub edi, TWO_PI
    jmp greater_than_2pi

; find the quadrant of the angle
quadrant_1:
    cmp edi, PI_HALF
    jg quadrant_2
    jmp sintab_lookup

quadrant_2:
    cmp edi, PI
    jg quadrant_3
    ; sin(x) - sin(pi-x)
    sub ecx, edi
    mov edi, ecx
    jmp sintab_lookup

quadrant_3:
    add ecx, PI_HALF
    cmp edi, edx
    jg quadrant_4
    ; sin(x+pi) = -sin(x)
    add edi, PI
    jmp sintab_lookup_neg

quadrant_4:
   sub ebx, edi
   mov edi, ebx
   jmp sintab_lookup_neg

sintab_lookup:
    mov eax, edi
    mov esi, PI_INC_RECIP
    imul esi
    shl edx, 16
    shr edx, 16
    xor eax, eax
    mov ax, WORD PTR[SINTAB + 2 * edx]
    jmp return


sintab_lookup_neg:
    mov eax, edi
    mov esi, PI_INC_RECIP
    imul esi
    shl edx, 16
    shr edx, 16
    xor eax, eax
    mov ax, WORD PTR[SINTAB + 2 * edx]
    neg eax
    
return:
	ret			; Don't delete this line!!!
FixedSin ENDP 
	


FixedCos PROC USES edi angle:FXPT

	mov edi, angle
	add edi, PI_HALF
	invoke FixedSin, edi

	ret			; Don't delete this line!!!	
FixedCos ENDP	
END

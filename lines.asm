;;;;;;;;;;;;;;;;;;;;;;;; STEPHANIE DIAO ;;;;;;;;;;;;;;;;;;;;;;;;
; #########################################################################
;
;   lines.asm _ Assembly file for EECS205 Assignment 2
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc

.DATA

    ;; If you need to, you can place global variables here
    
.CODE

    
DrawLine PROC USES ebx ecx edx esi edi x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD

    LOCAL delta_x:DWORD, delta_y:DWORD, inc_x:DWORD, inc_y:DWORD

    ;; calculate delta_x
    mov ecx, x1     ; store x1 in a register bc don't want two mem operands for sub
    sub ecx, x0
    jge pos_x
    neg ecx     ; changes negative value to positive 
pos_x:
    mov delta_x, ecx

    ;; calculate delta_y
    mov ecx, y1
    sub ecx, y0
    jge pos_y
    neg ecx
pos_y:
    mov delta_y, ecx

    ;; check if x0 < x1 and then set inc_x value
    mov ecx, x0
    cmp ecx, x1
    jge x_else
    mov inc_x, 1
    jmp y_if
x_else:
    mov inc_x, -1

    ;; check if y0 < y1 and then set inc_y value
y_if:
    mov ecx, y0
    cmp ecx, y1
    jge y_else
    mov inc_y, 1
    jmp delta_if
y_else:
    mov inc_y, -1

    ;; check if delta_x > delta_y and then set error values
delta_if: 
    mov ecx, delta_x
    cmp ecx, delta_y
    jle delta_else
    xor edx, edx
    mov eax, delta_x
    mov esi, 2
    div esi
    mov ebx, eax    ; store value of error into ebx
    jmp set_curr
delta_else:
    xor edx, edx
    mov eax, delta_y
    mov esi, 2
    div esi
    neg eax
    mov ebx, eax

set_curr:
    ;; set curr_x and curr_y values
    ; store curr_x in esi and curr_y in edi
    mov esi, x0
    mov edi, y0

    ;; invoke DrawPixel
    invoke DrawPixel, esi, edi, color

    ;; while loop
    jmp condition

loop_body:
    invoke DrawPixel, esi, edi, color       ; remember to reserve esi and edi for x0 and y0
    ; error is stored in ebx
    ; store prev error in another register --> ebp
    mov edx, ebx        ; prev_error = error

    ; check if prev_error > -delta_x
    neg delta_x
    cmp edx, delta_x
    jle if_2
    sub ebx, delta_y
    ; curr_x is stored inside esi
    add esi, inc_x

if_2:
    ; check if prev_error < delta_y
    neg delta_x
    cmp edx, delta_y
    jge condition
    add ebx, delta_x
    ; curr_y is stored inside edi
    add edi, inc_y

condition:
    ; make sure that curr_x != x1 OR curr_y != y1
    cmp esi, x1
    jne loop_body
    cmp edi, y1
    jne loop_body

return:        
    ret            ;;  Don't delete this line...you need it
DrawLine ENDP




END



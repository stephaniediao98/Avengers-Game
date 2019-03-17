; #########################################################################
;
;   blit.asm - Assembly file for EECS205 Assignment 3
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


.DATA

;; If you need to, you can place global variables here

.CODE

DrawPixel PROC USES edi esi ecx x:DWORD, y:DWORD, color:DWORD

; CHECK IF X IS IN BOUNDS [0, 640)
x_bounds_check:
    cmp x, 0
    jl out_of_bounds
    cmp x, 639
    jg out_of_bounds

; CHECK IF Y IS IN BOUNDS [0, 480)
y_bounds_check:
    cmp y, 0
    jl out_of_bounds
    cmp y, 479
    jg out_of_bounds

; index = x + dwWidth * y (dwWidth = screen width = 640)
; address = ScreenBitsPtr + index
get_address:
    ; get index
    mov eax, y
    imul eax, 640    ; eax = dwWidth * y
    add eax, x
    ; get address
    add eax, ScreenBitsPtr
    ; add color
    mov ecx, color
    mov BYTE PTR[eax], cl

out_of_bounds: 
    ret 			; Don't delete this line!!!
DrawPixel ENDP

BasicBlit PROC USES edi esi ecx edx ebx ptrBitmap:PTR EECS205BITMAP , xcenter:DWORD, ycenter:DWORD 
    LOCAL x0:DWORD, y0:DWORD, x:DWORD, y:DWORD, dwWidth:DWORD, dwHeight:DWORD, 
    bTransparent:BYTE, lpBytes:DWORD

    mov esi, ptrBitmap	; bitmap address pointer
    
    mov ebx, (EECS205BITMAP PTR[esi]).dwWidth
    mov dwWidth, ebx
    mov ebx, (EECS205BITMAP PTR[esi]).dwHeight
    mov dwHeight, ebx
    xor ebx, ebx
    mov bl, (EECS205BITMAP PTR[esi]).bTransparent
    mov bTransparent, bl
    mov ebx, (EECS205BITMAP PTR[esi]).lpBytes
    mov lpBytes, ebx

    xor esi, esi
    mov esi, 0  ; increment register
    

; INITIAL & FINAL X 
    ; intial x (x0 = xcenter - dwWidth/2)
    mov edx, xcenter
    mov x0, edx
    mov ebx, dwWidth
    sar ebx, 1
    sub x0, ebx

    ; final X (x = xcenter + dwWidth/2)
    mov edx, xcenter
    mov x, edx
    mov ebx, dwWidth
    sar ebx, 1
    add x, ebx

; INITIAL & FINAL Y 
    ; initial y (y0 = ycenter - dwHeight/2
    mov edx, ycenter
    mov y0, edx
    mov ebx, dwHeight
    sar ebx, 1
    sub y0, ebx

    ; final y (y = ycenter + dwHeight/2)
    mov edx, ycenter
    mov y, edx
    mov ebx, dwHeight
    sar ebx, 1
    add y, ebx

    jmp outer_condition

; LOOP BODY
enter_loop:

; OUTER LOOP CONDITION
outer_condition:
    mov edi, x
    cmp edi, x0
    jl inner_condition
    jmp outer_loop

; INNER LOOP CONDITION
inner_condition:
    inc y0
    mov edi, y
    cmp edi, y0
    jl return

; INNER LOOP BODY
inner_loop:
    mov ecx, dwWidth
    sub x0, ecx
    jmp outer_condition

; OUTER LOOP BODY
outer_loop:
    mov edi, lpBytes
    mov al, BYTE PTR[edi + esi]
    cmp al, bTransparent
    je increments

draw:
    invoke DrawPixel, x0, y0, al

increments:
    inc x0
    inc esi
    jmp outer_condition


return:    
    ret 			; Don't delete this line!!!	

BasicBlit ENDP



RotateBlit PROC USES edi ecx edx ebx esi lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
    LOCAL cosa:FXPT, sina:FXPT, bTransparent:BYTE, shiftx:DWORD, shifty:DWORD, dstHeight:DWORD,
    dstWidth:DWORD, dstX:DWORD, dstY:DWORD, srcX:DWORD, srcY:DWORD, screen_height:DWORD, 
    screen_width:DWORD, lpBytes:DWORD, dwWidth:DWORD, dwHeight:DWORD
    
    mov esi, lpBmp	;store bitmap pointer
    
    mov ebx, (EECS205BITMAP PTR[esi]).dwWidth
    mov dwWidth, ebx
    mov ebx, (EECS205BITMAP PTR[esi]).dwHeight
    mov dwHeight, ebx
    mov ebx, (EECS205BITMAP PTR[esi]).lpBytes
    mov lpBytes, ebx
    xor ebx, ebx
    mov bl, (EECS205BITMAP PTR[esi]).bTransparent
    mov bTransparent, bl
    
    
; CALC COS AND SIN 
calc_angles:
    invoke FixedCos, angle
    mov cosa, eax
    invoke FixedSin, angle
    mov sina, eax
    
; CALC SHIFTX
; shiftx = (dwWidth * cosa/2) - (dwHeight * sina/2)
shift_x:
    mov eax, dwWidth
    imul eax, cosa
    shl eax, 16
    shr eax, 16
    mov shiftx, eax
    sar shiftx, 1
    mov eax, dwHeight
    imul eax, sina
    sar eax, 1	
    sub shiftx, eax
    sar shiftx, 16


; CALC SHIFTY
; shifty = (dwHeight * cosa/2) - (dwWidth * sina/2)
shift_y:
    mov eax, dwHeight
    imul eax, cosa
    shl eax, 16
    shr eax, 16
    mov shifty, eax
    sar shifty, 1
    mov eax, dwWidth
    imul eax, sina
    sar eax, 1
    sub shifty, edx
    sar shifty, 16


; CALC DSTWIDTH
; dstWidth = dwWidth + dwHeight
dst_width:
    mov eax, dwWidth
    add eax, dwHeight
    mov dstWidth, eax
    ; set dstHeight = dstWidth
    mov dstHeight, eax
    
    ; set x = -dstWidth
    neg eax
    mov dstX, eax
    ; set y = -dstWidth
    mov dstY, eax


; ENTER FOR LOOP - set dstX
enter_loop:
    jmp outer_condition


; INNER LOOP
inner_loop:
    ; srcX = dstX * cosa + dstY * sina
    mov eax, dstX
    imul eax, cosa
    mov srcX, eax
    mov edx, dstY
    imul edx, sina
    add srcX, edx
    sar srcX, 16

    ; srcY = dstY * cosa - dstX * sina
    mov eax, dstY
    imul eax, cosa
    mov srcY, eax
    mov edx, dstX
    imul edx, sina
    sub srcY, edx
    sar srcY, 16

    cmp srcX, 0
    jl if_not_satisfied
    mov eax, dwWidth
    cmp srcX, eax
    jge if_not_satisfied
    cmp srcY, 0
    jl if_not_satisfied
    mov eax, dwHeight
    cmp srcY, eax
    jge if_not_satisfied
    
    ; xcenter + dstX - shiftx
    mov eax, xcenter
    add eax, dstX
    sub eax, shiftx
    cmp eax, 0
    jl if_not_satisfied
    mov eax, xcenter
    add eax, dstX
    sub eax, shiftx
    cmp eax, 639
    jge if_not_satisfied
    
    ; ycenter + dstY - shifty
    mov eax, ycenter
    add eax, dstY
    sub eax, shifty
    cmp eax, 0
    jl if_not_satisfied
    mov eax, ycenter
    add eax, dstY
    sub eax, shifty
    cmp eax, 479
    jge if_not_satisfied


    ; check if bitmap pixel is transparent (dwWidth * srcY + srcX)
    mov eax, srcY
    imul eax, dwWidth
    add eax, srcX
    add eax, lpBytes
    mov dl, BYTE PTR[eax]
    cmp dl, bTransparent
    je if_not_satisfied
    
    ; if all the statements have passed...
    ; 1st operand: xcenter + dstX - shiftx
    mov edi, xcenter
    add edi, dstX
    sub edi, shiftx    	; 1st operand
    ; 2nd operand: ycenter + dstY - shifty
    mov esi, ycenter
    add esi, dstY
    sub esi, shifty    	; 2nd operand
    
    invoke DrawPixel, edi, esi, dl
    
    
; IF IF CONDITIONS NOT SATISFIED
if_not_satisfied:
    add dstY, 1

; INNER CONDITION
inner_condition:
    mov ebx, dstHeight
    cmp dstY, ebx
    jl inner_loop
    inc dstX


; OUTER CONDITION
outer_condition:
    mov ebx, dstHeight
    neg ebx
    mov dstY, ebx
    mov eax, dstWidth
    cmp dstX, eax
    jl inner_condition

return:
    	ret 			; Don't delete this line!!!		
    RotateBlit ENDP



END
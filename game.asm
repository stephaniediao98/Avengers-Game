; #########################################################################
;
;   game.asm - Assembly file for EECS205 Assignment 4
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

;; Library imports
include \masm32\include\windows.inc
include \masm32\include\winmm.inc
includelib \masm32\lib\winmm.lib

include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib

include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
	

.DATA

Player STRUCT 
    posX DWORD ?
    posY DWORD ?
    bitmap DWORD ?
Player ENDS

Enemy STRUCT
    posX DWORD ?
    posY DWORD ?
    bitmap DWORD ?
Enemy ENDS

Trophy STRUCT 
    posX DWORD ?
    posY DWORD ?
    bitmap DWORD ?
    onScreen DWORD ?
Trophy ENDS

Stone STRUCT
    posX DWORD ?
    posY DWORD ?
    bitmap DWORD ?
Stone ENDS

Hero STRUCT
    posX DWORD ?
    posY DWORD ?
    bitmap DWORD ?
Hero ENDS

; initialize sprites 
ironman_player Player <100, 240, OFFSET ironman>
thanos_enemy Enemy <540, 240, OFFSET thanos>
infinity_gauntlet Trophy <320, 80, OFFSET gauntlet, 1>
red_stone Stone <600, 360, OFFSET red>
blue_stone Stone <30, 100, OFFSET blue>
green_stone Stone <250, 160, OFFSET green>
orange_stone Stone <75, 360, OFFSET orange>
yellow_stone Stone <525, 75, OFFSET yellow>
purple_stone Stone <360, 300, OFFSET purple>
cap Hero <500, 350, OFFSET captainamerica>
ant Hero <200, 300, OFFSET antman>
viking Hero <450, 200, OFFSET thor>
spider Hero <130, 75, OFFSET spiderman>
tree Hero <125, 175, OFFSET groot>

;; STRINGS
; start screen
instruction BYTE "Avoid Ironman & retrieve the infinity stones and the infinity gauntlet!", 0
instruction2 BYTE "You must get the infinity stones before you get the gauntlet.", 0
instruction3 BYTE "CONTROLS: Thanos- arrow keys.", 0
instruction4 BYTE "If you kill a hero, you get a powerup!", 0
powerups BYTE "Powerups include: getting more points or moving the gauntlet with your mouse.", 0
instruction5 BYTE "If you get an infinity stone, you get 50 points.", 0
instruction6 BYTE "If Ironman hits you, you lose 100 points.", 0
instruction7 BYTE "If your score gets below -2500 points, GAME OVER.", 0
instruction8 BYTE "To pause the game, hit P", 0
instruction9 BYTE "Hit enter to start.", 0

; pause screen
pause_game BYTE "Game PAUSED. Hit P to return to the game.", 0 

; win screen
won_game BYTE "Congrats! You got the infinity stones! SNAP!!!", 0
game_over BYTE "Oh no! Ironman beat you! Earth has been saved. :(", 0

; points and score 
plus_50 BYTE "You got an infinity stone! +50 points! :)", 0
minus_100 BYTE "You got hit by Ironman! -100 points! :(", 0
killed_hero BYTE "You killed an Avenger! Powerup! :)", 0
fmtStrScore BYTE "SCORE: %d", 0
outStrScore BYTE 256 DUP(0)

; powerups
bonus_50 BYTE "POWERUP!! +50 points!", 0
bonus_100 BYTE "POWERUPP!! +100 points!", 0
control_gauntlet BYTE "POWERUP!! You can move the gauntlet with your mouse!", 0

;; VARIABLES
level DWORD 0
paused DWORD 0
score DWORD 0
start DWORD 0
won DWORD 0
lost DWORD 0
stones_gotten DWORD 0
speed DWORD 0
gauntlet_enabled DWORD 0

;; SONGS

theme_song BYTE "avengers_theme_song.wav", 0



.CODE

;;; ---------- SPECIAL SCREENS ----------

StartScreen PROC 

    ; draw instructions
    invoke DrawStr, OFFSET instruction, 5, 100, 0ffh
    invoke DrawStr, OFFSET instruction2, 5, 125, 0ffh 
    invoke DrawStr, OFFSET instruction3, 5, 150, 0ffh
    invoke DrawStr, OFFSET instruction4, 5, 175, 0ffh
    invoke DrawStr, OFFSET powerups, 5, 200, 0ffh
    invoke DrawStr, OFFSET instruction5, 5, 225, 0ffh
    invoke DrawStr, OFFSET instruction6, 5, 250, 0ffh
    invoke DrawStr, OFFSET instruction7, 5, 275, 0ffh
    invoke DrawStr, OFFSET instruction8, 5, 300, 0ffh
    invoke DrawStr, OFFSET instruction9, 5, 325, 0ffh
        
    ret

StartScreen ENDP
    

DrawSprites PROC USES ecx edi

    ; draw thanos
    mov ecx, OFFSET thanos_enemy
    invoke BasicBlit, OFFSET thanos, (Enemy PTR[ecx]).posX, (Enemy PTR[ecx]).posY

    ; draw gauntlet
    mov ecx, OFFSET infinity_gauntlet
    invoke BasicBlit, OFFSET gauntlet, (Trophy PTR[ecx]).posX, (Trophy PTR[ecx]).posY

    ; draw stones
    mov ecx, OFFSET red_stone
    invoke BasicBlit, OFFSET red, (Stone PTR[ecx]).posX, (Stone PTR[ecx]).posY

    mov ecx, OFFSET orange_stone
    invoke BasicBlit, OFFSET orange, (Stone PTR[ecx]).posX, (Stone PTR[ecx]).posY

    mov ecx, OFFSET yellow_stone
    invoke BasicBlit, OFFSET yellow, (Stone PTR[ecx]).posX, (Stone PTR[ecx]).posY

    mov ecx, OFFSET green_stone
    invoke BasicBlit, OFFSET green, (Stone PTR[ecx]).posX, (Stone PTR[ecx]).posY

    mov ecx, OFFSET blue_stone
    invoke BasicBlit, OFFSET blue, (Stone PTR[ecx]).posX, (Stone PTR[ecx]).posY

    mov ecx, OFFSET purple_stone
    invoke BasicBlit, OFFSET purple, (Stone PTR[ecx]).posX, (Stone PTR[ecx]).posY

    ; draw ironman
    mov ecx, OFFSET ironman_player
    invoke BasicBlit, OFFSET ironman, (Player PTR[ecx]).posX, (Player PTR[ecx]).posY

    ; draw heroes
    mov ecx, OFFSET cap
    invoke BasicBlit, OFFSET captainamerica, (Hero PTR[ecx]).posX, (Hero PTR[ecx]).posY

    mov ecx, OFFSET ant
    invoke BasicBlit, OFFSET antman, (Hero PTR[ecx]).posX, (Hero PTR[ecx]).posY

    mov ecx, OFFSET viking
    invoke BasicBlit, OFFSET thor, (Hero PTR[ecx]).posX, (Hero PTR[ecx]).posY

    mov ecx, OFFSET spider
    invoke BasicBlit, OFFSET spiderman, (Hero PTR[ecx]).posX, (Hero PTR[ecx]).posY

    mov ecx, OFFSET tree
    invoke BasicBlit, OFFSET groot, (Hero PTR[ecx]).posX, (Hero PTR[ecx]).posY

    
return:
    ret

DrawSprites ENDP


PauseScreen PROC

    invoke DrawStr, offset pause_game, 50, 200, 0ffh

    ret

PauseScreen ENDP


WonScreen PROC 

    invoke DrawStr, offset won_game, 50, 200, 0ffh

    ret
    
WonScreen ENDP


LostScreen PROC

    invoke DrawStr, offset game_over, 50, 200, 0ffh

    ret
    
LostScreen ENDP


;;; ---------- START GAME ----------

DrawScreen PROC USES edi 

    invoke ClearScreen
    invoke DrawStarField

check_game_over:
    cmp game_over, 1
    jne check_won_game
    invoke LostScreen
    jmp return 

check_won_game:
    cmp won_game, 1
    jne check_start
    invoke WonScreen
    jmp return

check_start:
    cmp start, 1
    jne check_pause
    invoke StartScreen
    jmp return

check_pause:
    cmp paused, 1
    jne draw
    invoke PauseScreen
    jmp return

; no special screen needed
draw:
    ; draw sprites and level and score
    invoke DrawSprites

    push score
    push OFFSET fmtStrScore
    push OFFSET outStrScore
    call wsprintf
    add esp, 12
    invoke DrawStr, OFFSET outStrScore, 10, 420, 0ffh

return: 
    ret

DrawScreen ENDP


StartGame PROC 

    mov start, 0
    invoke DrawScreen

    ret

StartGame ENDP
    

;;; ---------- CHECK INTERSECT ----------

CheckIntersect PROC USES edi esi edx ecx oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP
    LOCAL oneW:DWORD, oneH:DWORD, twoW:DWORD, twoH:DWORD

; get one's height/2 and width/2
get_one_hw:
    mov edi, oneBitmap
    mov esi, (EECS205BITMAP PTR[edi]).dwWidth
    sar esi, 1
    mov oneW, esi
    mov esi, (EECS205BITMAP PTR[edi]).dwHeight
    sar esi, 1
    mov oneH, esi

; get two's height/2 and weight/2
get_two_hw:
    mov edi, twoBitmap
    mov esi, (EECS205BITMAP PTR[edi]).dwWidth
    sar esi, 1
    mov twoW, esi
    mov esi, (EECS205BITMAP PTR[edi]).dwHeight
    sar esi, 1
    mov twoH, esi

; check 1: one.x + width/2 > two.x - width/2
check_1:
    mov edi, oneX
    add edi, oneW
    mov esi, twoX
    sub esi, twoW

    cmp edi, esi
    jle no_intersection

; check 2: one.x - width/2 < two.x + width/2
check_2:
    mov edi, oneX
    sub edi, oneW
    mov esi, twoX
    add esi, twoH

    cmp edi, esi
    jge no_intersection

; check 3: one.y + height/2 > two.y - height/2
check_3:
    mov edi, oneY
    add edi, oneH
    mov esi, twoY
    sub esi, twoH

    cmp edi, esi
    jle no_intersection

; check 4: one.y - height/2 < two.y + height/2
check_4: 
    mov edi, oneY
    sub edi, oneH
    mov esi, twoY
    sub esi, twoH

    cmp edi, esi
    jge no_intersection


intersection:
   xor eax, eax
   mov eax, 1
   jmp return

no_intersection:
    xor eax, eax
    mov eax, 0

return: 
    ret

CheckIntersect ENDP


;;; ---------- GAME UPDATES ----------

GameUpdates PROC USES edi

    mov edi, KeyPress

check_start: 
    cmp start, 1
    jne check_paused
    cmp edi, VK_RETURN
    jne return 
    invoke StartGame
    jmp return

check_paused:
    cmp edi, VK_P
    jne return
    cmp paused, 1
    jne continue
    mov paused, 0 
    jmp return

continue: 
    mov paused, 1
    jmp return

return: 
ret

GameUpdates ENDP


;;; ---------- UPDATE SCORE ----------

UpdateScore PROC USES edi esi 

subtract_score:
    ; add 50 to score if ironman runs into thanos
    mov edi, OFFSET ironman_player
    mov esi, OFFSET thanos_enemy
    invoke CheckIntersect, (Player PTR[edi]).posX, (Player PTR[edi]).posY, OFFSET ironman, (Enemy PTR[esi]).posX, (Enemy PTR[esi]).posY, OFFSET thanos
    cmp eax, 1
    jne add_score
    sub score, 100
    invoke DrawStr, OFFSET minus_100, 50, 400, 0ffh
    jmp return

add_score:
    ; subtract 100 from score if thanos gets an infinity stone

got_red:
    mov edi, OFFSET thanos_enemy
    mov esi, OFFSET red_stone
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Stone PTR[esi]).posX, (Stone PTR[esi]).posY, OFFSET red
    cmp eax, 1
    jne got_orange
    add score, 50
    mov (Stone PTR[esi]).posX, -100
    mov (Stone PTR[esi]).posY, -100
    invoke DrawStr, OFFSET plus_50, 50, 400, 0ffh
    inc stones_gotten
    jmp return

got_orange:
    mov edi, OFFSET thanos_enemy
    mov esi, OFFSET orange_stone
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Stone PTR[esi]).posX, (Stone PTR[esi]).posY, OFFSET orange
    cmp eax, 1
    jne got_yellow
    add score, 50
    mov (Stone PTR[esi]).posX, -100
    mov (Stone PTR[esi]).posY, -100
    invoke DrawStr, OFFSET plus_50, 50, 400, 0ffh
    inc stones_gotten
    jmp return

got_yellow:
    mov edi, OFFSET thanos_enemy
    mov esi, OFFSET yellow_stone
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Stone PTR[esi]).posX, (Stone PTR[esi]).posY, OFFSET yellow
    cmp eax, 1
    jne got_green
    add score, 50
    mov (Stone PTR[esi]).posX, -100
    mov (Stone PTR[esi]).posY, -100
    invoke DrawStr, OFFSET plus_50, 50, 400, 0ffh
    inc stones_gotten
    jmp return

got_green:
    mov edi, OFFSET thanos_enemy
    mov esi, OFFSET green_stone
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Stone PTR[esi]).posX, (Stone PTR[esi]).posY, OFFSET green
    cmp eax, 1
    jne got_blue
    add score, 50
    mov (Stone PTR[esi]).posX, -100
    mov (Stone PTR[esi]).posY, -100
    invoke DrawStr, OFFSET plus_50, 50, 400, 0ffh
    inc stones_gotten
    jmp return

got_blue:
    mov edi, OFFSET thanos_enemy
    mov esi, OFFSET blue_stone
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Stone PTR[esi]).posX, (Stone PTR[esi]).posY, OFFSET blue
    cmp eax, 1
    jne got_purple
    add score, 50
    mov (Stone PTR[esi]).posX, -100
    mov (Stone PTR[esi]).posY, -100
    invoke DrawStr, OFFSET plus_50, 50, 400, 0ffh
    inc stones_gotten
    jmp return

got_purple:
    mov edi, OFFSET thanos_enemy
    mov esi, OFFSET purple_stone
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Stone PTR[esi]).posX, (Stone PTR[esi]).posY, OFFSET purple
    cmp eax, 1
    jne return
    add score, 50
    mov (Stone PTR[esi]).posX, -100
    mov (Stone PTR[esi]).posY, -100
    invoke DrawStr, OFFSET plus_50, 50, 400, 0ffh
    inc stones_gotten
    jmp return
    

return: 
    ret

UpdateScore ENDP


;;; ---------- MOVE GAUNTLET ----------

MoveGauntlet PROC USES edi esi edx ecx ebx

    ; move the gauntlet with the mouse
    mov edi, OFFSET MouseStatus
    mov esi, (MouseInfo PTR[edi]).horiz
    mov edx, (MouseInfo PTR[edi]).vert
    mov ebx, (MouseInfo PTR[edi]).buttons
    cmp ebx, MK_LBUTTON  

move_gauntlet:
    mov ecx, OFFSET infinity_gauntlet
    mov (Trophy PTR[ecx]).posX, esi
    mov (Trophy PTR[ecx]).posY, edx
    
    ret

MoveGauntlet ENDP


;;; ---------- MOVE IRONMAN ----------

MoveIronman PROC USES edi esi edx ecx s:DWORD
    LOCAL thanosX:DWORD, thanosY:DWORD, ironmanX:DWORD, ironmanY:DWORD

    mov ecx, s

current_coordinates:
    mov edi, OFFSET thanos_enemy
    mov esi, (Enemy PTR[edi]).posX
    mov thanosX, esi
    mov esi, (Enemy PTR[edi]).posY
    mov thanosY, esi

    mov edi, OFFSET ironman_player
    mov esi, (Player PTR[edi]).posX
    mov ironmanX, esi
    mov esi, (Player PTR[edi]).posY
    mov ironmanY, esi

    mov esi, OFFSET ironman_player

sub_x:
    mov edi, ironmanX
    mov edx, thanosX
    sub edi, edx
    cmp edi, 0
    jle add_x        ; if ironman.x < thanos.x --> need to add to ironman.x
    ; ironman.x > thanos.x --> need to subtract from ironman.x
    sub ironmanX, ecx
    mov edi, ironmanX
    mov (Player PTR[esi]).posX, edi
    jmp sub_y

add_x:
    cmp edi, 0
    je equal_x      ; if ironman.x == thanos.x --> don't do anything to ironman.x
    ; ironman.x < thanos.x --> need to add from ironman.x
    add ironmanX, ecx
    mov edi, ironmanX
    mov (Player PTR[esi]).posX, edi
    jmp sub_y

equal_x:
    mov edi, ironmanX
    mov (Player PTR[esi]).posX, edi
    mov edi, ironmanY
    cmp edi, thanosY
    jl addition
    sub edi, ecx
    mov (Player PTR[esi]).posY, edi
    jmp return

addition:
    add edi, ecx
    mov (Player PTR[esi]).posY, edi
    jmp return

sub_y:
    mov edi, ironmanY
    mov edx, thanosY
    sub edi, edx
    cmp edi, 0
    jle add_y
    sub ironmanY, ecx
    mov edi, ironmanY
    mov (Player PTR[esi]).posY, edi
    jmp return

add_y:
    cmp edi, 0
    je return
    add edi, ecx
    mov edi, ironmanY
    mov (Player PTR[esi]).posY, edi

return:
    ret
  

MoveIronman ENDP


;;; ---------- UPDATE SPEED ----------

UpdateSpeed PROC USES edi esi edx ebx ecx
; if Thanos gets to a hero and click with his mouse, he will kill it

check_cap:
    mov edi, OFFSET thanos_enemy
    mov esi, OFFSET cap
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Hero PTR[esi]).posX, (Hero PTR[esi]).posY, OFFSET thor
    cmp eax, 1
    jne check_viking
    add score, 100
    mov (Hero PTR[esi]).posX, -100
    mov (Hero PTR[esi]).posY, -100
    invoke DrawStr, OFFSET bonus_100, 50, 400, 0ffh
    jmp return

check_viking:
    mov esi, OFFSET viking
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Hero PTR[esi]).posX, (Hero PTR[esi]).posY, OFFSET thor
    cmp eax, 1
    jne check_tree
    add score, 50
    mov (Hero PTR[esi]).posX, -100
    mov (Hero PTR[esi]).posY, -100
    invoke DrawStr, OFFSET bonus_50, 50, 400, 0ffh
    jmp return

check_tree:
    mov esi, OFFSET tree
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Hero PTR[esi]).posX, (Hero PTR[esi]).posY, OFFSET groot
    cmp eax, 1
    jne check_ant
    add score, 100
    mov (Hero PTR[esi]).posX, -100
    mov (Hero PTR[esi]).posY, -100
    invoke DrawStr, OFFSET bonus_100, 50, 400, 0ffh
    jmp return

check_ant:
    mov esi, OFFSET ant
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Hero PTR[esi]).posX, (Hero PTR[esi]).posY, OFFSET antman
    cmp eax, 1
    jne check_spiderman
    add score, 50
    mov (Hero PTR[esi]).posX, -100
    mov (Hero PTR[esi]).posY, -100
    invoke DrawStr, OFFSET bonus_50, 50, 400, 0ffh
    jmp return

check_spiderman:
    mov esi, OFFSET spider
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Hero PTR[esi]).posX, (Hero PTR[esi]).posY, OFFSET spiderman
    cmp eax, 1
    jne return
    ;invoke MoveGauntlet
    mov (Hero PTR[esi]).posX, -100
    mov (Hero PTR[esi]).posY, -100
    invoke DrawStr, OFFSET control_gauntlet, 50, 400, 0ffh
    jmp enable_gauntlet

enable_gauntlet:
    mov gauntlet_enabled, 1

return: 
    ret
    
UpdateSpeed ENDP


;;; ---------- MOVE THANOS  ----------

MoveThanos PROC USES edi esi edx
; thanos movements controlled by a, s, d, and w keys

    mov edi, OFFSET thanos_enemy

move_left:
    mov esi, KeyPress
    cmp esi, VK_LEFT    
    jne move_right
    mov edx, (Enemy PTR[edi]).posX
    sub edx, 10
    mov (Enemy PTR[edi]).posX, edx

move_right: 
    mov esi, KeyPress
    cmp esi, VK_RIGHT
    jne move_up
    mov edx, (Enemy PTR[edi]).posX
    add edx, 10
    mov (Enemy PTR[edi]).posX, edx

move_up:
    mov esi, KeyPress
    cmp esi, VK_UP
    jne move_down
    mov edx, (Enemy PTR[edi]).posY
    sub edx, 10
    mov (Enemy PTR[edi]).posY, edx

move_down:
    mov esi, KeyPress
    cmp esi, VK_DOWN
    jne return
    mov edx, (Enemy PTR[edi]).posY
    add edx, 10
    mov (Enemy PTR[edi]).posY, edx


return:
    ret

MoveThanos ENDP


;;; ---------- CLEAR SCREEN ----------

ClearScreen PROC uses edi esi edx

    mov edi, 0
    mov esi, 0
    mov edx, ScreenBitsPtr
    jmp outer_condition

body:
    mov BYTE PTR [edx + edi], 0
    inc edi

inner_condition:
    cmp edi, 640
    jl body

outer_condition:
    inc esi
    xor edi, edi    
    add edx, 640    
    cmp esi, 480     
    jl body

      ret

ClearScreen ENDP


;;; ---------- END GAME ----------

EndGame PROC

    invoke DrawStr, OFFSET game_over, 10, 100, 0ffh
    invoke ClearScreen

    mov eax, 1
    ret

EndGame ENDP
    

;;; ---------- INITIALIZE GAME ----------

GameInit PROC USES edi esi ecx

    invoke ClearScreen 
    mov start, 1

invoke_sound_and_str:
    invoke PlaySound, OFFSET theme_song, 0, SND_FILENAME OR SND_ASYNC OR SND_LOOP

generate_random_number:
    rdtsc
    invoke nseed, eax

init_ironman:
    mov ecx, OFFSET ironman_player
    INVOKE BasicBlit, OFFSET ironman, (Player PTR[ecx]).posX, (Player PTR[ecx]).posY

	ret         ;; Do not delete this line!!!

GameInit ENDP


;;; ---------- PLAY GAME ----------

GamePlay PROC USES edi esi ecx

    ; set up screen
    invoke DrawScreen

move_sprites:
    invoke MoveThanos
    mov speed, 3
    invoke MoveIronman, speed
    ;invoke MoveGauntlet

check_for_updates: 
    invoke GameUpdates
    invoke UpdateScore
    invoke UpdateSpeed
    cmp gauntlet_enabled, 1
    jne check_game_lost
    invoke MoveGauntlet

; game ends if points < -2500
check_game_lost:
    cmp score, -2500
    jge check_game_won 
    jmp lost_game

; win if thanos gets gauntlet
check_game_won:
    cmp stones_gotten, 6
    jl return
    mov edi, OFFSET thanos_enemy
    mov esi, OFFSET infinity_gauntlet
    invoke CheckIntersect, (Enemy PTR[edi]).posX, (Enemy PTR[edi]).posY, OFFSET thanos, (Trophy PTR[esi]).posX, (Trophy PTR[esi]).posY, OFFSET gauntlet
    cmp eax, 1
    je winner
    jmp return

lost_game:
    mov gauntlet_enabled, 0
    mov lost, 1
    invoke ClearScreen
    invoke DrawStr, OFFSET game_over, 50, 200, 0ffh
    invoke DrawStarField
    ;invoke LostScreen
    jmp return

winner:
    mov gauntlet_enabled, 0
    mov won, 1
    invoke ClearScreen
    invoke DrawStr, OFFSET won_game, 50, 200, 0ffh
    invoke DrawStarField
    ;invoke WonScreen
    jmp return

return:
    ret         ;; Do not delete this line!!!

GamePlay ENDP

    

END
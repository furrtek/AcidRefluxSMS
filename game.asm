proc_game:
  ld   a,$01		; First RLI match
  ld   b,$A
  rst  $10
  
  ld   a,(REFRESH_P)	; Update player's sprite ?
  or   a
  call nz,update_pspr

  ; Copy sw-scrolled tile to VRAM. Todo: Make conditional, not each frame !
  ld   a,5		; Overscan color debug
  ld   b,7
  rst  $10

  ld   a,$40
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$40
  out  ($BF),a
  ld   a,(BG_SCROLL)	; /2 *32 = *16
  and  $0E
  sla  a
  sla  a
  sla  a
  sla  a
  ld   hl,SWSCROLL_BUF
  rst  $8
  ld   b,8
-:
  ld   a,(hl)		; Never gonna give you up - Rick Unroll
  out  ($BE),a		; Todo: add another scrolled tile (make room in VRAM) for 2nd parallax zone (there's time :))
  inc  hl
  ld   a,(hl)
  out  ($BE),a
  inc  hl
  ld   a,(hl)
  out  ($BE),a
  inc  hl
  ld   a,(hl)
  out  ($BE),a
  inc  hl
  dec  b
  jr   nz,-
  
  ld   a,6		; Overscan color debug
  ld   b,7
  rst  $10


  ld   hl,$3800+16+18	; Update score. Todo: Make conditional too !
  ld   b,6
  ld   de,SCORE_BCD
-:
  ld   a,(de)
  inc  de
  add  a,T_FONT
  call setbgtile
  inc  hl
  inc  hl
  dec  b
  jr   nz,-


  ; Gen platforms
  ld   a,(LAST_BG_SCROLL)
  and  $F8
  ld   b,a
  ld   a,(BG_SCROLL)	; Do we have to ?
  and  $F8
  cp   b
  jr   z,+++		; Nope

  ld   a,(BG_SCROLL)	; Make HEIGHT_IDX from BG_SCROLL
  xor  $FF
  srl  a
  srl  a
  srl  a
  and  $1F
  ld   (HEIGHT_IDX),a

  ld   a,(PLAT_COUNT)	; End of currently drawn platform ?
  dec  a
  jr   nz,+
  call getrand		; Yup: Start new one. Rand platform height with delta cap
  ld   a,(LAST_RAND)
  and  7
  inc  a
  ld   b,a
-:
  ld   a,(PLAT_HEIGHT)
  sub  b
  jr   c,++
  cp   3		; Max delta
  jr   c,++
  inc  b		; Inc until in range
  jr   -
++:
  ld   a,b
  ld   (PLAT_HEIGHT),a

  ld   e,0		; Platform start
  ld   a,(PLAT_HEIGHT)
  ld   c,a
  call genstripe

  ld   a,(LAST_RAND)	; Rand platform length (4~19)
  and  15
  add  a,4
  ld   (PLAT_COUNT),a
  jr   +++

+:
  ld   (PLAT_COUNT),a	; Still the same platform
  dec  a
  jr   nz,+
  ld   e,2		; Platform end
  ld   a,(PLAT_HEIGHT)
  ld   c,a
  call genstripe
  jr   +++

+:
  ld   e,1		; Platform center
  ld   a,(PLAT_HEIGHT)
  ld   c,a
  call genstripe
+++:


  ; TODO: MOVE LOWER !
  ld   a,(ANIM_EN)	; Only animate player's little legs if we're enabled and on the ground
  ld   b,a
  ld   a,(PLAYER_ONGROUND)
  and  b
  jr   z,+
  ld   a,(BG_SCROLL)	; Scroll delta = animation speed
  ld   b,a
  ld   a,(LAST_BG_SCROLL)
  sub  b
  jr   z,+
  ld   b,a
  ld   a,(PLAYER_ANIM)
  add  a,b
  ld   (PLAYER_ANIM),a
+:


  ; Check player collision
  ld   a,(BG_SCROLL)
  xor  $FF
  ld   b,a

  ld   a,(PLAYER_X)
  add  a,32		; Player's "center"
  add  a,b
  srl  a
  srl  a
  srl  a
  and  $1F
  ld   hl,HEIGHTS       ; Get player's height
  rst  $8
  ld   c,a

  ld   a,(PLAYER_X)
  add  a,9+32		; Player's right edge
  add  a,b
  srl  a
  srl  a
  srl  a
  and  $1F
  ld   hl,HEIGHTS	; Next column's height
  rst  $8
  ld   d,a
  
  cp   c
  jr   nc,+
  ; Next platform is higher than current one, might hit
  ; Check Y

  ld   a,d		; Ugly :)
  add  a,11
  ld   d,a
  ld   a,(PLAYER_Y)
  srl  a
  srl  a
  srl  a
  cp   d
  jr   c,+

  ; Hit: push player left
  xor  a
  ld   (ANIM_EN),a

  ld   a,(LAST_BG_SCROLL)
  ld   b,a
  ld   a,(BG_SCROLL)
  sub  b
  ld   b,a

  ld   a,(PLAYER_X)
  add  a,b
  ld   (PLAYER_X),a
  cp   8
  jr   nc,++          	; Trig game over
  ld   a,ST_SET_GAMEOVER
  ld   (STATE),a
  jr   ++
+:

  ; No collision
  ld   a,1
  ld   (ANIM_EN),a
  ld   a,(PLAYER_RR)	; Player wants to go right ?
  or   a
  jr   z,++
  ld   a,(PLAYER_X)	; Right cap
  cp   256-50
  jr   nc,++
  inc  a
  ld   (PLAYER_X),a
++:

  ld   a,1
  ld   (REFRESH_P),a	; X changed

  ; Gravity
  ld   a,(BG_SCROLL)
  xor  $FF
  ld   b,a
  ld   a,(PLAYER_X)
  add  a,4+20		; Player's "center". Todo: Here be glitch, use ALL ground heights beneath player and take highest !
  add  a,b
  srl  a
  srl  a
  srl  a
  and  $1F
  ld   hl,HEIGHTS       ; Player's height
  rst  $8
  ld   c,a

  ld   a,(PLAYER_YFINE+1)
  ld   (PLAYER_Y),a

  ld   a,c		; Ugly :)
  add  a,10
  ld   c,a
  ld   a,(PLAYER_Y)
  srl  a
  srl  a
  srl  a
  cp   c
  jr   nc,+

  ld   hl,(PLAYER_YSPD)	; Accelerate if falling
  ld   de,$0040
  add  hl,de
  ld   (PLAYER_YSPD),hl
  ld   d,h
  ld   e,l
  ld   hl,(PLAYER_YFINE)
  add  hl,de
  ld   (PLAYER_YFINE),hl
  
  ld   a,1
  ld   (REFRESH_P),a	; Y changed

  xor  a
  ld   (PLAYER_ONGROUND),a
  jr   ++

+:
  ld   hl,0		; Reset Y speed
  ld   (PLAYER_YSPD),hl
  ld   a,(PLAYER_Y)	; Round to ground
  and  $F8
  ld   (PLAYER_Y),a
  ld   a,1
  ld   (REFRESH_P),a	; Y changed
  ld   a,1
  ld   (PLAYER_ONGROUND),a

++:


  ; BG scrolling
  ld   hl,(BG_SCROLL_HD)	; 12.4
  ld   de,(SCROLL_SPD)
  add  hl,de
  ld   (BG_SCROLL_HD),hl	; 0000HHHH HHHHLLLL

  sla  l
  rl   h
  ld   a,h
  ld   (BG_SCROLL_D8),a         ; 000HHHHH
  sla  l
  rl   h
  ld   a,h
  ld   (BG_SCROLL_D4),a         ; 00HHHHHH
  sla  l
  rl   h
  ld   a,h
  ld   (BG_SCROLL_D2),a         ; 0HHHHHHH
  ld   a,(BG_SCROLL)
  ld   (LAST_BG_SCROLL),a
  sla  l
  rl   h
  ld   a,h
  ld   (BG_SCROLL),a            ; HHHHHHHH
  


  ; Todo: Gravity for objects here !



  call readjp
  
  ld   a,(JP_CURRENT)		; Right
  and  $08
  ld   (PLAYER_RR),a		; Right Request !
  
  ld   a,(JP_CURRENT)		; Left
  bit  2,a
  jr   z,+
  ld   a,(PLAYER_X)		; Left cap
  cp   12
  jr   c,+
  dec  a
  ld   (PLAYER_X),a
+:

  ld   a,(JP_ACTIVE)		; Button 1
  bit  4,a
  jr   z,+
  ld   a,(PLAYER_ONGROUND)	; Start jump only from ground
  or   a
  jr   z,+
  ld   a,1
  ld   (JUMPING),a
+:

  ld   a,(JP_CURRENT)		; Jump control (press duration)
  bit  4,a
  jr   z,+
  ld   a,(JUMPING)		; Only do this if a jump was started
  or   a
  jr   z,+
  inc  a			; Cap jump height by timer
  cp   14
  jr   nc,+
  ld   (JUMPING),a
  ld   hl,-$0200		; Force negative Y speed
  ld   (PLAYER_YSPD),hl
  ld   d,h
  ld   e,l
  ld   hl,(PLAYER_YFINE)	; Add to Y pos
  add  hl,de
  ld   (PLAYER_YFINE),hl
  ld   a,1
  ld   (REFRESH_P),a		; Y changed
  jr   ++
+:
  xor  a
  ld   (JUMPING),a		; Reset jump, avoid Cheetahmen-style infinite jumps :)
++:


  ; Object trig and gen here !


  jp   +			; Todo
  ; Update cloud's face
  ld   a,(TIMER)
  and  15
  jr   nz,+
  ld   a,$87
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix
  ld   a,(CLOUD_FACE)
  ld   b,a
  sla  a
  add  a,42
  out  ($BE),a
  ld   a,b
  inc  a
  cp   3
  jr   nz,++
  xor  a
++:
  ld   (CLOUD_FACE),a
+:

  call playmusic

  ; Score stuff
  ld   hl,SCORE_ADD	; Todo: Change !
  ld   a,0
  ld   (hl),a
  inc  hl
  ld   a,0
  ld   (hl),a
  inc  hl
  ld   a,0
  ld   (hl),a
  inc  hl
  ld   a,0
  ld   (hl),a
  inc  hl
  ld   a,0
  ld   (hl),a
  inc  hl
  ld   a,2
  ld   (hl),a

  ld   a,(SCORE_BCD+2)
  push af

  ; Inc score
  ld   hl,SCORE_BCD+5
  ld   de,SCORE_ADD+5
  ld   c,0
  ld   b,6
-:
  ld   a,(hl)
  add  a,c
  ld   c,a
  ld   a,(de)
  add  a,c
  ld   c,0
  cp   10
  jr   c,+
  sub  10
  ld   c,1
+:
  ld   (hl),a
  dec  hl
  dec  de
  dec  b
  jr   nz,-

  ; Speed up ?
  ld   a,(SCORE_BCD+2)
  ld   b,a
  pop  af
  cp   b
  jr   z,++

  ld   hl,(SCROLL_SPD)
  ld   de,-$0002
  add  hl,de
  ld   (SCROLL_SPD),hl

  ld   a,(BPM_INC)
  inc  a        	; Todo: Change ?
  ld   (BPM_INC),a
  
  and  1
  jr   z,++
  ld   a,(NOTES_GEN)
  cp   15
  jr   z,+
  inc  a
  ld   (NOTES_GEN),a
+:
  ld   b,a
  call genpattern
  call genpad
++:

  ret

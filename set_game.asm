setup_game:
  di

  ld   hl,vdpregs_game
  ld   b,vdpregs_game_end-vdpregs_game
  ld   c,$BF
  otir

  ld   a,(TIMER)	; Re-seed PRNG
  ld   (LAST_RAND),a
  ld   a,4		; Start with 4 notes
  ld   (NOTES_GEN),a
  ld   b,a
  call genpattern
  call genpad

  call clearvram

  ld   hl,pal_game
  ld   b,32
  call loadpal

  ld   de,0		; Load tiles
  ld   hl,tile_empty
  ld   b,1
  call loadtiles
  ld   de,T_BLACK*32
  ld   hl,tile_black
  ld   b,1
  call loadtiles
  ld   de,T_CLOUDA*32
  ld   hl,tiles_cloud1
  ld   b,10
  call loadtiles
  ld   de,T_CLOUDB*32
  ld   hl,tiles_cloud2
  ld   b,12
  call loadtiles
  ld   de,T_CLOUDC*32
  ld   hl,tiles_cloud3
  ld   b,12
  call loadtiles
  ld   de,T_TILESET*32
  ld   hl,tiles_tileset
  ld   b,15
  call loadtiles
  ld   de,T_OBJECTS*32
  ld   hl,tiles_objects
  ld   b,24
  call loadtiles
  ld   de,T_FONT*32
  ld   hl,tiles_font
  ld   b,16
  call loadtiles
  ld   de,T_PLAYER*32
  ld   hl,tiles_player
  ld   b,8*20
  call loadtiles

  ; Pre-gen software scrolled tiles
  ; Copy non-scrolled tile in slot 0
  ld   hl,tiles_tileset+((T_BGSA-1)*32)
  ld   de,SWSCROLL_BUF
  ld   bc,32
  ldir

  ; Slots 1~7 are scrolled
  ld   hl,SWSCROLL_BUF
  ld   de,SWSCROLL_BUF+32
  ld   c,7			; 7 slots
-:
  ld   b,8                     	; 8 pixel lines
--:
  ld   a,(hl)			; 4bpp
  inc  hl
  rlca
  ld   (de),a
  inc  de
  ld   a,(hl)
  inc  hl
  rlca
  ld   (de),a
  inc  de
  ld   a,(hl)
  inc  hl
  rlca
  ld   (de),a
  inc  de
  ld   a,(hl)
  inc  hl
  rlca
  ld   (de),a
  inc  de
  dec  b
  jr   nz,--
  dec  c
  jr   nz,-

  ld   a,$24		; Sprite setup
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix

  ld   a,$D0
  out  ($BE),a		; EOL
  push ix
  pop  ix

  ld   a,T_CLOUDA	; BG map: clouds. Todo: list
  ld   (TIDX),a
  ld   de,$3800+(32*2*2)+16
  ld   hl,map_cloud1
  ld   bc,$0502
  call maptiles
  ld   a,T_CLOUDA
  ld   (TIDX),a
  ld   de,$3800+(32*3*2)
  ld   hl,map_cloud1
  ld   bc,$0502
  call maptiles
  ld   a,T_CLOUDB
  ld   (TIDX),a
  ld   de,$3800+(32*5*2)+26
  ld   hl,map_cloud23
  ld   bc,$0602
  call maptiles
  ld   a,T_CLOUDC
  ld   (TIDX),a
  ld   de,$3800+(32*7*2)+50
  ld   hl,map_cloud23
  ld   bc,$0602
  call maptiles
  ld   a,T_CLOUDC
  ld   (TIDX),a
  ld   de,$3800+(32*8*2)+36
  ld   hl,map_cloud23
  ld   bc,$0602
  call maptiles
  
  ld   a,$00		; Black score bar
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$38+$40
  out  ($BF),a
  ld   b,32*2
-:
  ld   a,T_BLACK
  out  ($BE),a
  push ix
  pop  ix
  xor  a
  out  ($BE),a
  nop
  nop
  dec  b
  jr   nz,-
  
  ld   hl,$3800+20	; Write "SCORE:"
  ld   b,10+T_FONT
-:
  ld   a,b
  call setbgtile
  inc  hl
  inc  hl
  inc  b
  ld   a,b
  cp   16+T_FONT
  jr   nz,-

  ld   hl,HEIGHT_IDX 	; Init BG with multiple stripes
  xor  a
  ld   (hl),a
  ld   b,32
-:
  ld   e,1		; Ground type
  ld   c,3              ; -Y of ground
  call genstripe
  inc  (hl)
  dec  b
  jr   nz,-

  ld   hl,HEIGHTS	; Init heights array
  ld   a,3
  ld   b,32
-:
  ld   (hl),a
  inc  hl
  dec  b
  jr   nz,-

  ld   a,16 		; Init variables
  ld   (PLAT_COUNT),a
  ld   a,3
  ld   (PLAT_HEIGHT),a
  ld   hl,$9000
  ld   (PLAYER_X_HD),hl
  ld   hl,$3000
  ld   (PLAYER_Y_HD),hl
  ld   hl,0
  ld   (BG_SCROLL_HD),hl
  ld   (PLAYER_YSPD),hl
  xor  a
  ld   (PLAYER_ONGROUND),a
  ld   (JUMPING),a
  ld   (PLAYER_RR),a
  ld   (BG_SCROLL),a
  ld   (BG_SCROLL_D2),a
  ld   (BG_SCROLL_D4),a
  ld   (BG_SCROLL_D8),a
  ld   (LAST_BG_SCROLL),a
  ld   (NOTEOFF_CNT),a
  ld   (ECHOOFF_CNT),a
  ld   (PERCOFF_CNT),a
  ld   (CLOUD_FACE),a
  ld   (BPM_ACC),a
  ld   (PATTERN_IDXA),a
  ld   (PATTERN_IDXB),a
  ld   (HEIGHT_IDX),a
  ld   (OBJ_DATA+0),a
  ld   (OBJ_DATA+5),a
  ld   (ANIM_EN),a
  ld   (PLAYER_ANIM),a
  ld   (TIMER),a
  ld   (RLI_STEP),a
  ld   hl,1		; Todo: Change !
  ld   (OBJ_TIMER),hl
  ld   a,20        	; Todo: Change !
  ld   (BPM_INC),a
  ld   a,2
  ld   (PATTERN_GRAN),a	; Unused ?

  ld   hl,SCORE_BCD	; Reset score
  xor  a
  ld   b,12
-:
  ld   (hl),a
  inc  hl
  dec  b
  jr   nz,-

  ld   hl,-$0020
  ld   (SCROLL_SPD),hl

  ld   a,ST_GAME
  ld   (STATE),a
  
  ld   a,%11100110	; Turn screen on
  ld   b,1
  rst  $10
  
  ei

  ret

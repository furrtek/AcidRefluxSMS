setup_gameover:
  di
  
  call stfu

  ld   hl,vdpregs_title
  ld   b,vdpregs_title_end-vdpregs_title
  ld   c,$BF
  otir
  
  call clearvram

  ld   hl,pal_gameover
  ld   b,17
  call loadpal

  ld   de,0*32		; Load tiles
  ld   hl,tiles_gameover
  ld   b,$5A
  call loadtiles
  ld   de,T_FONTGO*32
  ld   hl,tiles_font
  ld   b,16
  call loadtiles

  ld   a,$00		; Sprite setup (none)
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

  ld   a,0
  ld   (TIDX),a
  ld   de,$3800+(32*2*2)+20
  ld   hl,map_gameover
  ld   bc,$0E13
  call maptiles

  ld   hl,$3800+((11+(14*32))*2)
  ld   b,10+T_FONTGO
-:
  ld   a,b
  call setbgtile
  inc  hl
  inc  hl
  inc  b
  ld   a,b
  cp   16+T_FONTGO
  jr   nz,-

  ; Show score
  ld   hl,$3800+((17+(14*32))*2)
  ld   c,T_FONTGO
  call writescore

  xor  a
  ld   (TIMER),a
  ld   (RES_EN),a
  
  ld   a,ST_GAMEOVER
  ld   (STATE),a
  
  ld   a,%11100110	; Turn screen on
  ld   b,1
  rst  $10

  ei

  ret

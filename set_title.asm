setup_title:
  di
  
  call stfu

  ld   hl,vdpregs_title
  ld   b,vdpregs_title_end-vdpregs_title
  ld   c,$BF
  otir

  call clearvram

  ld   hl,pal_title
  ld   b,17
  call loadpal

  ld   de,0*32
  ld   hl,tiles_title
  ld   b,195
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

  xor  a
  ld   (TIDX),a
  ld   de,$3800+(32*2*2)+16
  ld   hl,map_title
  ld   bc,$1015
  call maptiles
  
  xor  a
  ld   (TIMER),a
  ld   (RES_EN),a
  
  ld   a,ST_TITLE
  ld   (STATE),a

  ld   a,%11100110	; Turn screen on
  ld   b,1
  rst  $10

  ei

  ret

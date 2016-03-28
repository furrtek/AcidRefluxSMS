update_pspr:
  xor  a
  ld   (REFRESH_P),a

  ld   a,$00		; Sprite Y position VRAM update
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix

  ld   a,(PLAYER_Y_HD+1)
  call setpy

  ld   a,(PLAYER_Y_HD+1)
  add  a,16
  call setpy
  
  ld   a,$80		; Sprite X position VRAM update
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix

  ld   a,(PLAYER_ANIM)
  srl  a		; Slow down
  and  7
  sla  a		; *20
  sla  a
  ld   e,a
  sla  a
  sla  a
  add  a,e
  ld   e,a		; E = animation frame #

  ld   a,(PLAYER_X_HD+1)
  ld   c,a
  ld   a,T_PLAYER
  call setpxn

  ld   a,(PLAYER_X_HD+1)
  ld   c,a
  ld   a,T_PLAYER+(2*5)
  call setpxn

  ret
  
setpy:
  ld   b,5
-:
  out  ($BE),a
  push ix
  pop  ix
  dec  b
  jr   nz,-
  ret
  
setpxn:			; Needs to preserve E !
  add  a,e
  ld   d,a		; D is tile #
  ld   b,5
-:
  ld   a,c		; Set X
  out  ($BE),a
  add  a,8
  ld   c,a
  push ix
  pop  ix
  ld   a,d		; Set tile #
  out  ($BE),a
  inc  d
  inc  d
  nop
  nop
  nop
  dec  b
  jr   nz,-
  ret

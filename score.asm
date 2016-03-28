writescore:
  ld   b,6
  ld   de,SCORE_BCD
-:
  ld   a,(de)
  inc  de
  add  a,c
  call setbgtile
  inc  hl
  inc  hl
  dec  b
  jr   nz,-
  ret

incscore:
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
  ret

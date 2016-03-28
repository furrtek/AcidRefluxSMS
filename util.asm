getrand:
  push de
  push hl
  ld   de,(LAST_RAND)
  ld   a,d
  ld   h,e
  ld   l,253
  or   a
  sbc  hl,de
  sbc  a,0
  sbc  hl,de
  ld   d,0
  sbc  a,d
  ld   e,a
  sbc  hl,de
  jr   nc,+
  inc  hl
+:
  ld   (LAST_RAND),hl
  pop  hl
  pop  de
  ret
  
clearwram:		; Clear whole work RAM
  ld   hl,$C000
  ld   bc,$1FFF
  ld   d,0
-:
  ld   (hl),d
  dec  bc
  ld   a,b
  or   c
  jr   nz,-
  ret
  
clearvram: 		; Clear whole VRAM
  xor  a
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$40
  out  ($BF),a
  ld   bc,$4000
-:
  xor  a
  out  ($BE),a
  dec  bc
  ld   a,b
  or   c
  jr   nz,-
  ret
  
loadpal:  		; Load B colors from HL
  ld   a,$00
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$C0
  out  ($BF),a
  ld   c,$BE
  otir
  ret
  
setbgtile:
  push af
  ld   a,l
  out  ($BF),a
  push ix
  pop  ix
  ld   a,h
  or   $40
  out  ($BF),a
  pop  af
  out  ($BE),a
  push ix
  pop  ix
  xor  a
  out  ($BE),a
  ret

maptiles:		; DE = VRAM address, HL = map address, (TIDX) = tile offset, BC = width/height
  ld   a,e
  out  ($BF),a
  ld   a,d
  or   $40
  push ix
  pop  ix
  out  ($BF),a

  push bc

-:
  ld   a,(TIDX)
  add  a,(hl)
  out  ($BE),a
  ld   a,0
  adc  a,0
  inc  hl
  or   (hl)
  out  ($BE),a
  inc  hl
  dec  b
  ld   a,b
  or   a
  jr   nz,-

  ld   a,32*2		; Next line
  add  a,e
  jr   nc,+
  inc  d
+:
  ld   e,a
  ld   a,e
  out  ($BF),a
  push ix
  pop  ix
  ld   a,d
  or   $40
  out  ($BF),a

  pop  af
  push af
  ld   b,a
  dec  c
  ld   a,c
  or   a
  jr   nz,-
  pop  af
  ret

loadtiles:		; DE = VRAM address, HL = tile data, B = tile count
  ld   a,e
  out  ($BF),a
  ld   a,d
  or   $40
  push ix
  pop  ix
  out  ($BF),a
-:
  ld   c,8
--:
  ld   a,(hl)
  out  ($BE),a
  push ix
  pop  ix
  inc  hl
  ld   a,(hl)
  out  ($BE),a
  push ix
  pop  ix
  inc  hl
  ld   a,(hl)
  out  ($BE),a
  push ix
  pop  ix
  inc  hl
  ld   a,(hl)
  out  ($BE),a
  push ix
  pop  ix
  inc  hl
  dec  c
  jp   nz,--
  dec  b
  jp   nz,-
  ret
  
readjp:
  ld   hl,JP_LAST
  in   a,($DC)
  ld   b,a
  xor  $FF
  ld   (JP_CURRENT),a
  ld   c,a
  ld   a,(hl)
  ld   (hl),b
  xor  b		; Difference
  and  c                ; Rising edges
  ld   (JP_ACTIVE),a
  ret
  
  ; Gravity for active objects
  ld   hl,OBJ_DATA+0
  ld   a,(hl)
  or   a
  jr   z,+
  bit  7,a
  jr   nz,+

  ; Get ground level under object
  ld   a,(BG_SCROLL)
  xor  $FF
  add  a,256-20
  srl  a
  srl  a
  srl  a
  and  $1F
  ld   hl,HEIGHTS
  rst  $8
  add  a,10
  sla  a
  sla  a
  sla  a
  add  a,12
  ld   b,a

  ld   hl,(OBJ_DATA+3)
  sla  l
  rl   h
  sla  l
  rl   h
  sla  l
  rl   h
  sla  l
  rl   h
  ld   a,h
  cp   b
  jr   c,++
  ld   a,(OBJ_DATA+0)
  set  7,a
  ld   (OBJ_DATA+0),a
  jr   +
++:
  ld   hl,(OBJ_DATA+3)		; Continue dropping TODO
  ld   de,80
  add  hl,de
  ld   (OBJ_DATA+3),hl
  ld   h,a
  ld   a,$20			; Y
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix
  ld   a,h
  out  ($BE),a
  push ix
  pop  ix
  out  ($BE),a
  push ix
  pop  ix
+:

  ld   a,(OBJ_DATA+0)
  bit  7,a
  call nz,scroll_obj_a



+:
  ld   hl,(OBJ_DATA+6)
  add  hl,de
  ld   (OBJ_DATA+6),hl
  ; Update sprite VRAM tile X
  ld   a,$C4
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix
  sla  l
  rl   h
  sla  l
  rl   h
  sla  l
  rl   h
  sla  l
  rl   h
  ld   a,h
  cp   4
  jr   nc,++
  xor  a			; Free object
  ld   (OBJ_DATA+5),a
  ld   a,$22			; Y (move off screen)
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$C0
  out  ($BE),a
  push ix
  pop  ix
  out  ($BE),a
  push ix
  pop  ix
  jr   +
++:
  out  ($BE),a			; X
  push ix
  pop  ix
  ld   a,$C6
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix
  ld   a,h
  add  a,8
  out  ($BE),a			; X
  push ix
  pop  ix
  
  
  
  
  
    ; Object trigger and generator
  ld   hl,(OBJ_TIMER)
  dec  hl
  ld   a,h
  or   l
  jp   nz,+

  ; See if we have a free object
  ld   hl,OBJ_DATA+0
  ld   c,0
  ld   a,(hl)
  or   a
  jr   z,++
  inc  hl			; +5
  inc  hl
  inc  hl
  inc  hl
  inc  hl
  ld   c,2
  ld   a,(hl)
  or   a
  jr   nz,+++			; Abort if not
++:
  call getrand
  ld   a,(LAST_RAND)
  srl  a
  and  $7
  inc  a
  cp   7
  jr   c,++
  ld   a,4			; Totally arbitraty default
++:
  ld   (hl),a
  and  $7F
  dec  a
  sla  a
  sla  a
  ld   b,a
  inc  hl

  ; Update sprites VRAM tile N/X
  ld   a,$C0
  add  a,c
  add  a,c
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix

  ld   de,$0F00
  ld   (hl),e
  inc  hl
  ld   (hl),d
  inc  hl
  xor  a			; Y
  ld   (hl),a
  inc  hl
  ld   (hl),a

  ld   a,$F0
  out  ($BE),a			; X
  push ix
  pop  ix
  ld   a,T_OBJECTS		; Tile #
  add  a,b
  out  ($BE),a
  push ix
  pop  ix

  ld   a,$F8
  out  ($BE),a			; X
  push ix
  pop  ix
  ld   a,T_OBJECTSR		; Tile #
  add  a,b
  out  ($BE),a
  push ix
  pop  ix
  
  ld   a,$20			; Y
  add  a,c
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix
  xor  a			; Top of screen (hidden)
  out  ($BE),a
  push ix
  pop  ix
  out  ($BE),a
  push ix
  pop  ix

+++:
  call getrand			; Todo: CHANGE !
  ld   a,(LAST_RAND)
  and  $1F
  inc  a
  ld   l,a
  ld   h,0
+:
  ld   (OBJ_TIMER),hl
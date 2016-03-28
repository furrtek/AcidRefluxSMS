scroll_obj_a:
  ld   de,-$001C		; TODO: CHANGE !
  ld   hl,(OBJ_DATA+1)
  add  hl,de
  ld   (OBJ_DATA+1),hl
  ; Update sprite VRAM tile X
  ld   a,$C0
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
  jr   nc,+
  xor  a			; Free object
  ld   (OBJ_DATA),a
  ld   a,$20			; Y (move off screen)
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
  ret
+:
  out  ($BE),a			; X
  push ix
  pop  ix
  ld   a,$C2
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
  ret
  
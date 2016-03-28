genstripe:
  push hl
  push bc

  ld   a,(HEIGHT_IDX)	; Store new height
  ld   hl,HEIGHTS
  rst  $8
  ld   (hl),c
  call getstripex

  xor  a
  ld   (STRIPE_ZONE),a

  ld   b,0		; Start at Y 0
-:
  ld   a,(STRIPE_ZONE)	; Jump table indexed by zone
  push hl
  ld   hl,jt_stripe
  sla  a
  rst  $8
  inc  hl
  ld   h,(hl)
  ld   l,a
  call dojump
  pop  hl
  call setbgtile

  ld   a,l		; Next line
  add  a,32*2
  jr   nc,+
  inc  h
+:
  ld   l,a

  inc  b
  ld   a,b
  cp   14
  jr   nz,-

  pop  bc
  pop  hl
  ret
  
jt_stripe:
  .dw sz_0
  .dw sz_1
  .dw sz_2
  .dw sz_3
  .dw sz_4
  .dw sz_5

sz_0:                 	; First unique bush tile
  ld   hl,STRIPE_ZONE
  inc  (hl)
  ld   d,0
  ld   a,T_BGF
  ret

sz_1:                	; Replicated bush tiles (height)
  inc  d
  ld   a,d
  cp   c
  jr   c,+
  ld   hl,STRIPE_ZONE
  inc  (hl)
  ld   d,0
+
  ld   a,T_BGS
  ret
  
sz_2:			; Ground
  inc  d
  ld   a,d
  cp   4
  jr   c,+
  ld   hl,STRIPE_ZONE
  inc  (hl)
  ld   d,0
+
  ld   a,T_GND
  ret

sz_3:			; Platform edge
  inc  d
  ld   a,e
  or   a
  jr   z,+++
  dec  a
  jr   z,++
  
  ; End of platform (2)
  ld   a,d
  dec  a
  jr   nz,+
  ld   a,T_COR_UR
  ret
+:
  dec  a
  jr   nz,+
  ld   a,T_COR_DR
  ret
+:
  dec  a
  jr   nz,+
  ld   a,T_COL_A
  ret
+:
  dec  a
  jr   nz,+
  ld   a,T_COL_B
  ret
+:
  ld   hl,STRIPE_ZONE
  inc  (hl)
  ld   a,T_COL_C
  ret
  
++:
  ; Middle of platform (1)
  ld   a,d
  dec  a
  jr   nz,+
  ld   a,T_COR_U
  ret
+:
  dec  a
  jr   nz,+
  ld   a,T_COR_D
  ret
+:
  dec  a
  jr   nz,+
  ld   a,T_DIRT_A
  ret
+:
  ld   a,5
  ld   (STRIPE_ZONE),a
  ld   a,T_DIRT_B
  ret

+++:
  ; Start of platform (0)
  ld   a,d
  dec  a
  jr   nz,+
  ld   a,T_COR_UL
  ret
+:
  dec  a
  jr   nz,+
  ld   a,T_COR_DL
  ret
+:
  dec  a
  jr   nz,+
  ld   a,T_COL_A
  ret
+:
  dec  a
  jr   nz,+
  ld   a,T_COL_B
  ret
+:
  ld   hl,STRIPE_ZONE
  inc  (hl)
  ld   a,T_COL_C
  ret
  
sz_4:			; Fill down (column)
  ld   a,b
  cp   13
  jr   c,+
  ld   a,T_COL_A
  ret
+:
  ld   a,T_COL_C
  ret
  
sz_5:			; Fill down (dirt)
  ld   a,T_DIRT_B
  ret

getstripex:
  push de
  ld   hl,$3800+(10*32*2)
  ld   a,(HEIGHT_IDX)
  and  $1F		; Better be sure !
  sla  a
  ld   d,0
  ld   e,a
  add  hl,de
  pop  de
  ret

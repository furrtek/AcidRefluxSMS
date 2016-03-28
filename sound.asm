readpad:
  ld   hl,pattern_pad
  ld   a,(PATTERN_IDXA)
  rst  $8
  or   a
  jr   nz,+
  ld   a,%11011111	; Volume
  out  ($7F),a
  ret

+:
  ld   hl,PATTERN_B
  ld   a,(PATTERN_IDXB)
  rst  $8

  sla  a
  ld   hl,note_lut
  rst  $8
  or   %11000000	; Tone LSBs
  out  ($7F),a
  inc  hl
  ld   a,(hl)
  out  ($7F),a
  
  ld   a,%11010100	; Volume
  out  ($7F),a
  ret


readpat:
  ; Percs
  ld   a,(PATTERN_IDXA)
  ld   b,a
  ld   hl,percs
  rst  $8
  or   a
  jr   z,+
  dec  a
  sla  a
  ld   hl,percdefs
  rst  $8
  ld   (PERCOFF_CNT),a
  inc  hl
  ld   a,(hl)
  or   %11100000
  out  ($7F),a
+:

  ld   hl,PATTERN_A
  ld   a,b
  rst  $8
  or   a
  jr   z,+

  dec  a
  sla  a
  ld   hl,note_lut
  rst  $8
  or   %10000000	; Tone LSBs
  out  ($7F),a
  inc  hl
  ld   a,(hl)
  out  ($7F),a
  
  ld   a,%10010000	; Max volume
  out  ($7F),a
  
  ld   a,4
  ld   (NOTEOFF_CNT),a

+:
  ld   hl,PATTERN_A
  ld   a,(PATTERN_IDXA)
  dec  a
  and  15
  rst  $8
  or   a
  ret  z

  dec  a
  sla  a
  ld   hl,note_lut
  rst  $8
  or   %10100000	; Tone LSBs
  out  ($7F),a
  inc  hl
  ld   a,(hl)
  out  ($7F),a

  ld   a,%10110100	; Volume
  out  ($7F),a
  
  ld   a,4
  ld   (ECHOOFF_CNT),a
  ret
  
  
stfu:
  ld   a,%10011111
  out  ($7F),a
  ld   a,%10111111
  out  ($7F),a
  ld   a,%11011111
  out  ($7F),a
  ld   a,%11111111
  out  ($7F),a
  ret

  
genpad:
  ld   hl,PATTERN_B
  ld   b,4		; Number of notes to place
-:
  ;0~7
  call getrand
  and  7
  ld   (hl),a
  inc  hl
  dec  b
  jr   nz,-
  ret

  
genpattern:
  push bc

  ld   hl,PATTERN_A
  ld   b,16		; Clear pattern
  xor  a
-:
  ld   (hl),a
  inc  hl
  dec  b
  jr   nz,-

  pop  bc

  ld   d,0
-:
  ;0~21 = 15+3+3
  call getrand
  and  15
  ld   c,a
  ld   a,(LAST_RAND)
  sra  a
  and  3
  add  a,c
  ld   c,a
  ld   a,(LAST_RAND+1)
  and  3
  add  a,c

--:
  ld   hl,PATTERN_A
  ld   a,d
  rst  $8
  or   a
  jr   z,+
  ld   a,d
  inc  a
  and  15
  ld   d,a
  jr   --
+:
  ld   (hl),c
  ld   a,d
  add  a,c
  and  15
  ld   d,a

  dec  b
  jr   nz,-
  ret
  
  
playmusic:
  ; "Music" stuff
  ld   a,(NOTEOFF_CNT)
  or   a
  jr   z,++		; Zero: do nothing
  dec  a
  jr   nz,+		; Not 1: just dec
  ld   a,%10011111	; One: STFU CH1
  out  ($7F),a
+:
  ld   (NOTEOFF_CNT),a
++:

  ld   a,(ECHOOFF_CNT)
  or   a
  jr   z,++		; Zero: do nothing
  dec  a
  jr   nz,+		; Not 1: just dec
  ld   a,%10111111	; One: STFU CH2
  out  ($7F),a
+:
  ld   (ECHOOFF_CNT),a
++:

  ld   a,(PERCOFF_CNT)
  or   a
  jr   z,+		; Zero: do nothing (should already be silent)
  ld   b,a
  or   %11110001
  out  ($7F),a
  ld   a,b
  inc  a
  ld   (PERCOFF_CNT),a
+:

  ld   a,(BPM_ACC)	; Step music ?
  ld   hl,BPM_INC
  add  a,(hl)
  ld   (BPM_ACC),a
  jr   nc,+++
  call readpat
  call readpad
  ld   a,(PATTERN_IDXA)
  or   a
  jr   nz,+
  ld   a,(PATTERN_IDXB)
  inc  a
  and  3
  ld   (PATTERN_IDXB),a
  xor  a
+:
  inc  a
  and  15
++:
  ld   (PATTERN_IDXA),a
+++:
  ret


updfx:
  ld   a,(FXPTR)	;VGM play
  ld   l,a
  ld   a,(FXPTR+1)
  ld   h,a
  ld   a,(FXIDX)	;Offset
  ld   b,a
  add  a,l
  jr   nc,+
  inc  h
+:
  ld   l,a
-:
  ld   a,(hl)
  cp   $66		;End
  ret  z
  cp   $62		;Wait frame
  jr   z,+
  inc  hl
  inc  b
  ld   a,(hl)
  out  ($7F),a
  inc  hl
  inc  b
  jr   -
+:
  ld   a,b
  inc  a
  ld   (FXIDX),a
  ret

prepfx:
  ld   a,l
  ld   (FXPTR),a
  ld   a,h
  ld   (FXPTR+1),a
  xor  a
  ld   (FXIDX),a
  ret
  
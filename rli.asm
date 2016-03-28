jt_rli:
  .dw  RLI_0
  .dw  RLI_1
  .dw  RLI_2
  .dw  RLI_3
  .dw  RLI_4
  .dw  RLI_5
  .dw  RLI_6

RLI_0:
  xor  a		; First active line, reloads to 0 (no choice)
  ld   b,$08
  rst  $10

  ;ld   a,1		; Overscan color debug
  ;ld   b,7
  ;rst  $10
  
  ld   a,34		; RLI line
  ld   b,$A
  rst  $10
  ret
  
RLI_1:
  ld   a,(BG_SCROLL_D2)	; First cloud line
  ld   b,$08
  rst  $10
  
  ;ld   a,2		; Overscan color debug
  ;ld   b,7
  ;rst  $10

  ld   a,15		; RLI line
  ld   b,$A
  rst  $10
  ret

RLI_2:
  ld   a,(BG_SCROLL_D4)	; First cloud line
  ld   b,$08
  rst  $10
  
  ;ld   a,3		; Overscan color debug
  ;ld   b,7
  ;rst  $10

  ld   a,23		; RLI line
  ld   b,$A
  rst  $10
  ret

RLI_3:
  ld   a,(BG_SCROLL_D8)	; Third cloud line
  ld   b,$08
  rst  $10
  
  ;ld   a,4		; Overscan color debug
  ;ld   b,7
  ;rst  $10

  ld   a,7		; RLI line
  ld   b,$A
  rst  $10
  ret
  
RLI_4:
  ld   a,(BG_SCROLL_D4)	; Horizon line
  ld   b,$08
  rst  $10

  ;ld   a,5		; Overscan color debug
  ;ld   b,7
  ;rst  $10

  ld   a,$10		; RLI line
  ld   b,$A
  rst  $10
  ret

RLI_5:
  ld   a,(BG_SCROLL)
  ld   b,$08
  rst  $10

  ;ld   a,$E		; Overscan color debug
  ;ld   b,7
  ;rst  $10

  ld   a,$FF		; RLI line
  ld   b,$A
  rst  $10
  ret
  
RLI_6:
  xor  a		; Is this required ?
  ld   (RLI_STEP),a
  ret

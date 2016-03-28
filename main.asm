; Acid Reflux by Furrtek and Robotwo
; For the Sega Master System
; SMSPower coding compo 2016

; Assembles with WLA-DX

.MEMORYMAP
DEFAULTSLOT 0
SLOTSIZE $8000
SLOT 0 $0000
.endme

.ROMBANKMAP
BANKSTOTAL 1
BANKSIZE $8000
BANKS 1
.ENDRO

; Possible states / VBL handlers
.DEFINE ST_SET_TITLE 0
.DEFINE ST_TITLE 1
.DEFINE ST_SET_GAME 2
.DEFINE ST_GAME 3
.DEFINE ST_SET_GAMEOVER 4
.DEFINE ST_GAMEOVER 5

.SDSCTAG 1.0,"ACID REFLUX","Runner done for SMSPower coding compo 2016","Furrtek and Robotwo"

.BANK 0 SLOT 0
.ORG $0000
  di
  im   1
  jp   main
  
.ORG $0008
  add  a,l		; LUT A=(HL+A)
  jr   nc,+
  inc  h
+:
  ld   l,a
  ld   a,(hl)
  ret
  
.ORG $0010
  out  ($BF),a		; Set VDP reg B to A
  ld   a,b
  or   $80
  out  ($BF),a
  ret

.ORG $0038
  push af
  push bc
  push de
  push hl
  in   a,($BF)
  and  $80
  ld   (VBLFLAG),a
  jr   nz,+
  ld   hl,jt_rli	; Catched RLI
  ld   a,(RLI_STEP)
  ld   b,a
  inc  a
  ld   (RLI_STEP),a
  ld   a,b
  sla  a
  rst  $8
  inc  hl
  ld   h,(hl)
  ld   l,a
  call dojump
+:
  pop  hl
  pop  de
  pop  bc
  pop  af
  ei
  ret

.ORG $0066
  retn


main:
  ld   sp,$DFF0

  call clearwram

  ld   a,%10100000	; Vblank interrupt plz
  ld   b,1
  rst  $10

  ei

-:
  ld   a,(VBLFLAG)	; Wait for vblank
  or   a
  jr   z,-
  xor  a
  ld   (VBLFLAG),a
  ld   (RLI_STEP),a	; Needs to be done quick !

  ld   a,(STATE)	; STATE MASHEEN jumptable
  ld   hl,jt_state
  sla  a
  rst  $8
  inc  hl
  ld   h,(hl)
  ld   l,a
  call dojump

  ld   a,(TIMER)
  inc  a
  ld   (TIMER),a

  jp -			; Main loop

dojump:
  jp   (hl)

jt_state:
  .dw setup_title
  .dw proc_title
  .dw setup_game
  .dw proc_game
  .dw setup_gameover
  .dw proc_gameover


proc_title:
  call delayen
  or   a
  ret  z
  call readjp
  ld   a,(JP_ACTIVE)
  and  $30		; Button 1 or 2
  ret  z
  ld   a,ST_SET_GAME
  ld   (STATE),a
  ret

proc_gameover:
  call delayen
  or   a
  ret  z
  call readjp
  ld   a,(JP_ACTIVE)
  bit  4,a		; Button 1
  ret  z
  ld   a,ST_SET_TITLE	; Should we go to game directly ?
  ld   (STATE),a
  ret
  

delayen:
  ld   a,(RES_EN)
  or   a
  ret  nz
  ld   a,(TIMER)
  cp   $40
  ld   a,0
  ret  nz
  ld   a,1
  ld   (RES_EN),a
  ret


.INCLUDE "tiledefs.inc"
.INCLUDE "player.asm"
.INCLUDE "sound.asm"
.INCLUDE "rli.asm"
.INCLUDE "game.asm"
.INCLUDE "set_title.asm"
.INCLUDE "set_game.asm"
.INCLUDE "set_gameover.asm"
.INCLUDE "util.asm"
.INCLUDE "objects.asm"
.INCLUDE "stripes.asm"
.INCLUDE "data.asm"
.INCLUDE "ram.asm"

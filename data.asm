;tiledata:
;  .db 0 	;EOL

tiles_font:
.include "data/tiles_font_score.inc"

tile_empty:
  .db $00 $00 $FF $00 $00 $00 $FF $00
  .db $00 $00 $FF $00 $00 $00 $FF $00
  .db $00 $00 $FF $00 $00 $00 $FF $00
  .db $00 $00 $FF $00 $00 $00 $FF $00
  
tile_black:
  .db $FF $FF $FF $FF $FF $FF $FF $FF
  .db $FF $FF $FF $FF $FF $FF $FF $FF
  .db $FF $FF $FF $FF $FF $FF $FF $FF
  .db $FF $FF $FF $FF $FF $FF $FF $FF

tiles_player:
.include "data/tiles_player0.inc"
.include "data/tiles_player1.inc"
.include "data/tiles_player2.inc"
.include "data/tiles_player3.inc"
.include "data/tiles_player4.inc"
.include "data/tiles_player5.inc"
.include "data/tiles_player6.inc"
.include "data/tiles_player7.inc"

;tiles_barbpm:
;.include "data/tiles_barbpm.inc"

;tiles_cloud:
;.include "data/tiles_cloud.inc"
;tiles_faces:
;.include "data/tiles_faces.inc"
;tiles_blow:
;.include "data/tiles_blow.inc"

tiles_title:
.include "data/tiles_title.inc"
map_title:
.include "data/map_title.inc"

tiles_gameover:
.include "data/tiles_gameover.inc"
map_gameover:
.include "data/map_gameover.inc"

tiles_cloud1:
.include "data/tiles_cloud1.inc"
tiles_cloud2:
.include "data/tiles_cloud2.inc"
tiles_cloud3:
.include "data/tiles_cloud3.inc"

map_cloud1:
  .db 0,0,1,0,2,0,3,0,4,0
  .db 5,0,6,0,7,0,8,0,9,0
map_cloud23:
  .db 0,0,1,0,2,0,3,0,4,0,5,0
  .db 6,0,7,0,8,0,9,0,10,0,11,0

tiles_tileset:
.include "data/tiles_tileset.inc"

tiles_objects:
.include "data/tiles_objects.inc"

pal_title:
  .db $00 $14 $38 $2C $3E $01 $02 $07 $1B $0F $10 $21 $32
  .db $00,$00,$00,$00

pal_game:
  .db $32,$21,$10,$3E,$18,$04,$2E,$0F,$1B,$07,$02,$01,$00
  .db $00,$00,$00
  .db $00 $11 $26 $38 $14 $2C $08 $02 $17 $3F $00 $33 $3F
  .db $00,$00,$00

pal_gameover:
  .db $32 $21 $10 $3E $18 $04 $2E $0F $1B $07 $02 $01 $00
  .db $00,$00,$00,$00

; 0~3: Nothing, accent, hat, kick
percs:
  ;.db 1,2,2,2,3,2,2,2,3,2,2,2,3,2,2,2
  .db 1,1,1,2,3,0,2,3,0,0,1,2,3,0,2,0

percdefs:
  .db $FF-15, 5
  .db $FF-11, 6
  .db $FF-13, 4

pattern_pad:
  .db 1,1,1,0,1,0,0,1,1,0,1,1,1,0,1,0

; 3 octaves in acoustic scale: C D E F# G A Bb
note_lut:
  .dw 13575, 12042, 10759, 9485, 8971, 7948, 7680
  .dw 6668, 5901, 5379, 4622, 4365, 3854, 3840
  .dw 3334, 2830, 2570, 2311, 2063, 1807, 1800

vdpregs_title:
.db %00000100,$80,%10100000,$81,$0E,$82,$FF,$83,$FF,$85,$FB,$86,$F0,$87,$00,$88,$00,$89,$00,$8A
vdpregs_title_end:

vdpregs_game:
.db %01110100,$80,%10100010,$81,$0E,$82,$FF,$83,$FF,$85,$FB,$86,$FF,$87,$00,$88,$00,$89,$00,$8A
vdpregs_game_end:

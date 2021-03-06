.ENUM $C000 EXPORT
LAST_RAND DW
VBLFLAG DB
TIMER DB
JP_CURRENT DB
JP_LAST DB
JP_ACTIVE DB

FXPTR DW
FXIDX DB
TIDX DB
STATE DB
RLI_STEP DB

BG_SCROLL_HD DW		; Used 12.4: 0000HHHH HHHHLLLL
BG_SCROLL DB		; Used
BG_SCROLL_D2 DB         ; Used
BG_SCROLL_D4 DB         ; Used
BG_SCROLL_D8 DB         ; Used
PLAT_COUNT DB           ; Used
PLAT_HEIGHT DB		; Used

LAST_BG_SCROLL DB	; Used

PLAYER_X_HD DW		; Used
PLAYER_Y_HD DW		; Used
PLAYER_YSPD DW		; Used
PLAYER_ONGROUND DB	; Used
JUMPING DB		; Used
PLAYER_RR DB            ; Used

NOTEOFF_CNT DB
ECHOOFF_CNT DB
PERCOFF_CNT DB

CLOUD_FACE DB

BPM_INC DB
BPM_ACC DB

PATTERN_GRAN DB		; Granularity (2=4/16, 1=8/16 or 0=16/16)
PATTERN_A DS 16
PATTERN_B DS 4

PATTERN_IDXA DB
PATTERN_IDXB DB

HEIGHT_IDX DB		; Used
HEIGHTS DS 32		; Used

SWSCROLL_BUF DS 256

STRIPE_ZONE DB

OBJ_DATA DS 10		; Type.b X.w Y.w *2
OBJ_TIMER DW

SCORE_BCD DS 6		; Keep these two consecutive !
SCORE_ADD DS 6

RES_EN DB
SCROLL_SPD DW		; Used

ANIM_EN DB		; Used
PLAYER_ANIM DB		; Used

NOTES_GEN DB		; Used

REFRESH_P DB		; Used Player sprite refresh request flag

SCROLL_DELTA DB		; Used

.ENDE

;***********************************
;** OCCUPIED REGS.: A5,A6         **
;** (C) 1990 STalin OF F.F.       **
;***********************************

EXEC=0             ;-1 FOR EXECUTABLE

 IFEQ EXEC,-1
SCR1=$70000
 ELSE
SCR1=$F0000
 ENDIF
SCR2=SCR1+$8000

 JMP START

BUFF:
 DS.B 2500,0


VBL:
 MOVE.B SCREENS+1(PC),$FF8201
 MOVE.B SCREENS+2(PC),$FF8203
 ST SYNCF
 MOVEM.L D0-D7/A0-A4,-(SP)
 MOVE.W #$000,(A6)

;CPEK:
; LEA COLTAB+400,A5
; SUBQ.W #2,A5
; CMP.L #COLTAB,A5
; BNE.S CC1
;   LEA COLTAB+400(PC),A5
;CC1:
; MOVE.L A5,CPEK+2
;   MOVE.L SCOLA(PC),A0
;   MOVE.W SCOL(PC),(A0)
; LEA 398(A5),A0
; MOVE.W (A0),SCOL
; MOVE.L A0,SCOLA
; MOVE.W #0,(A0)

 MOVEM.L (SP)+,D0-D7/A0-A4
; CLR.B $FFFA1B
; MOVE.B #1,$FFFA21
; MOVE.B #8,$FFFA1B
 RTE
SCOL: DC.W 0
SCOLA: DC.L BUFF
SYNCF: DC.W 0


MAIN:
 TST.B SYNCF
 BEQ.S MAIN
 CLR.B SYNCF

 JSR BIGSCROLL(PC)

 MOVE.L SCREENS(PC),D0
 MOVE.L SCREENS+4(PC),D1
 EXG.L D0,D1
 MOVE.L D0,SCREENS
 MOVE.L D1,SCREENS+4

 MOVE.W #$777,(A6)

 MOVE.B $FFFC02,D0
 CMP.B #$66,D0
 BEQ EXIT

 BRA.S MAIN


BIGSCROLL:   ;PEK!
 LEA BUFF,A0
 MOVE.L A0,A2

 MOVE.L SCREENS(PC),A1

N@=0
L@=48
 REPEAT
   MOVEM.W (A0)+,D0-D7
   MOVE.W D0,L@(A1)
   MOVE.W D1,L@+8(A1)
   MOVE.W D2,L@+16(A1)
   MOVE.W D3,L@+24(A1)
   MOVE.W D4,L@+32(A1)
   MOVE.W D5,L@+40(A1)
   MOVE.W D6,L@+48(A1)
   MOVE.W D7,L@+56(A1)

   MOVE.W D0,L@+160(A1)
   MOVE.W D1,L@+8+160(A1)
   MOVE.W D2,L@+16+160(A1)
   MOVE.W D3,L@+24+160(A1)
   MOVE.W D4,L@+32+160(A1)
   MOVE.W D5,L@+40+160(A1)
   MOVE.W D6,L@+48+160(A1)
   MOVE.W D7,L@+56+160(A1)

   MOVE.W D0,L@+320(A1)
   MOVE.W D1,L@+8+320(A1)
   MOVE.W D2,L@+16+320(A1)
   MOVE.W D3,L@+24+320(A1)
   MOVE.W D4,L@+32+320(A1)
   MOVE.W D5,L@+40+320(A1)
   MOVE.W D6,L@+48+320(A1)
   MOVE.W D7,L@+56+320(A1)

   MOVE.W D0,L@+480(A1)
   MOVE.W D1,L@+8+480(A1)
   MOVE.W D2,L@+16+480(A1)
   MOVE.W D3,L@+24+480(A1)
   MOVE.W D4,L@+32+480(A1)
   MOVE.W D5,L@+40+480(A1)
   MOVE.W D6,L@+48+480(A1)
   MOVE.W D7,L@+56+480(A1)
N@=N@+1
L@=L@+640
 UNTILEQ N@,50

BS3:  ;PEK!
 LEA FONT,A0
 MOVEM.L (A0)+,D0-D3
 MOVEM.L D0-D3,(A2)
 MOVEM.L D0-D3,800(A2)
 MOVE.L A0,BS3+2
 ADD.W #16,A2
 MOVE.L A2,BIGSCROLL+2

 SUBQ.B #1,FLIP           ;CHECK BUFFER FULL
 BNE.S BS2
     MOVE.L #BUFF,BIGSCROLL+2
     MOVE.B #50,FLIP
BS2:

 SUBQ.B #1,FLIP+1         ;CHECK NEW LETTER
 BNE.S BS1
     MOVE.B #32,FLIP+1
     MOVEQ #0,D0
BS4:   ;PEK!
     MOVE.B ASCII,D0
     BNE.S BS5
        MOVE.L #ASCII,BS4+2
        MOVE.B ASCII(PC),D0
BS5:
     SUB.B #64,D0
     SWAP D0         ;*512
     LSR.L #7,D0
     LEA FONT(PC),A0
     ADD.W D0,A0
     MOVE.L A0,BS3+2
     ADDQ.L #1,BS4+2
BS1:
 RTS
FLIP: DC.B 50,32


START:
 CLR.L -(SP)
 MOVE.W #$20,-(SP)
 TRAP #1
 ADDQ.L #6,SP
 MOVE.L D0,SPAR+4

 MOVE.W #0,$484

 PEA MOUSE
 MOVE.W #1,-(SP)
 MOVE.W #25,-(SP)
 TRAP #14
 ADDQ.L #8,SP

 CLR.W -(SP)     ;SETSCR
 PEA SCR1
 PEA SCR1
 MOVE.W #5,-(SP)
 TRAP #14
 ADD.L #12,SP

 LEA $FF8240,A0
 LEA OPAL,A1
 MOVEQ #7,D0
 BSR COPY
 LEA $FF8240,A1
 MOVEQ #7,D0
CLPAL:
 CLR.L (A1)+
 DBRA D0,CLPAL

 LEA SCR1,A0
 MOVE.W #9000,D0
CLS:
; MOVE.L #$FFFF0000,(A0)+
 CLR.L (A0)+
 CLR.L (A0)+
 DBRA D0,CLS

 BSR MAKEBIGFONT

 LEA PAL,A0
 LEA $FF8240,A1
 MOVEQ #7,D0
 BSR COPY

 MOVE.W #$2700,SR
 MOVE.L $70,OVBL
     LEA $FF8240,A6
; BSR INITRAST
 MOVE.L #VBL,$70
 MOVE.W #$2100,SR
 JMP MAIN

EXIT:
 MOVE.W #$2700,SR
FLUSH:
 BTST #0,$FFFC00          ;IS A CHARACTER WAITING ?
 BEQ.S FL1                ;BR. IF NOT
 MOVE.B $FFFC02,D0        ;READ CHARACTER (& IGNORE IT)
 BRA.S FLUSH              ;CHECK FOR ANOTHER
FL1:
; BSR REMOVERAST
 MOVE.L OVBL,$70
 MOVE.W #$2300,SR

 MOVE.W #1,-(SP)
 PEA $F8000
 PEA $F8000
 MOVE.W #5,-(SP)
 TRAP #14
 ADD.L #12,SP

 LEA OPAL,A0
 LEA $FF8240,A1
 MOVEQ #7,D0
 BSR COPY

 MOVE.L SPAR+4,-(SP)
 MOVE.W #$20,-(SP)
 TRAP #1
 ADDQ.L #6,SP

 PEA MOUSE+2
 MOVE.W #1,-(SP)
 MOVE.W #25,-(SP)
 TRAP #14
 ADDQ.L #8,SP
 IFEQ EXEC,-1
   CLR.W -(SP)
   TRAP #1
 ENDIF
 ILLEGAL
COPY:
 MOVE.L (A0)+,(A1)+
 DBRA D0,COPY
 RTS
MFP1:
 DC.W 0

INITRAST:
 LEA COLTAB+400(PC),A5
 LEA $FF8240,A6
 MOVE.L $120,SPAR2
 MOVE.B $FFFA09,SPAR4
 MOVE.B $FFFA07,SPAR4+1
 MOVE.B $FFFA13,SPAR4+2
 CLR.B $FFFA07
 CLR.B $FFFA09
 MOVE.L #RASTER1,$120
 ORI.B #1,$FFFA07
 ORI.B #1,$FFFA13
 RTS

REMOVERAST:
 MOVE.B SPAR4,$FFFA09
 MOVE.B SPAR4+1,$FFFA07
 MOVE.B SPAR4+2,$FFFA13
 MOVE.L SPAR2,$120
 RTS

RASTER1:
 MOVE.W (A5)+,(A6)
 BCLR #0,$FFFA0F
 RTE


MAKEBIGFONT:
 LEA FONT(PC),A0
 LEA TEMP(PC),A1
 MOVE.W #3839,D3
MBF1:
   MOVE.W (A0)+,D0
   MOVE.W D0,D1
   MOVEQ #0,D2
   MOVEQ #15,D4
MBF2:
     ROXR.W #1,D0
     ROXR.L #1,D2
     ROXR.W #1,D1
     ROXR.L #1,D2
   DBRA D4,MBF2
   MOVE.L D2,(A1)+
 DBRA D3,MBF1

 LEA TEMP(PC),A0
 LEA FONT(PC),A1
 MOVE.W #3839,D0
 BSR COPY
 RTS


OKEY: DC.L 0,0
OHBL: DC.L 0
SPAR: DS.L 8,0
SPAR1: DC.L 0
SPAR2: DC.L 0
SPAR3: DC.L 0
SPAR4: DC.L 0
SPAR5: DC.W 0
OMFP:
 DC.W 0
COLTAB:

N@=0
 REPEAT
 DC.W $000,$000,$000
 DC.W $001,$100,$100
 DC.W $002,$200,$200
 DC.W $003,$300,$300
 DC.W $004,$400,$400
 DC.W $005,$500,$500
 DC.W $006,$600,$600
 DC.W $007,$700,$700
 DC.W $007,$700,$700
 DC.W $006,$600,$600
 DC.W $005,$500,$500
 DC.W $004,$400,$400
 DC.W $003,$300,$300
 DC.W $002,$200,$200
 DC.W $001,$100,$100
 DC.W $000,$000,$000

 DC.W 0,0

 DC.W $000,$000,$000
 DC.W $110,$010,$010
 DC.W $220,$020,$020
 DC.W $330,$030,$030
 DC.W $440,$040,$040
 DC.W $550,$050,$050
 DC.W $660,$060,$060
 DC.W $770,$070,$070
 DC.W $770,$070,$070
 DC.W $660,$060,$060
 DC.W $550,$050,$050
 DC.W $440,$040,$040
 DC.W $330,$030,$030
 DC.W $220,$020,$020
 DC.W $110,$010,$010
 DC.W $000,$000,$000

 DC.W 0,0
N@=N@+1
 UNTILEQ N@,4


PAL:
 DC.W $000,$070,$007,$007,$557,$557,$007,$007
 DC.W $717,$717,$717,$717,$717,$717,$717,$717
OPAL:
 DS.W 16,0
OVBL:
 DC.L 0

ASCII:
 DC.B "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 DC.B "INTELLIGENT TO CAUSE DISEASE    ZZZZZZZZZAP GAMES     "
 DC.B 0
 ALIGN.W

MOUSE:
 DC.B $12,$1A,$14,8

SCREENS:
 DC.L SCR1,SCR2

CLOCK:
 DC.W 0,0

FONT:
 DS.B 32*8,0
 IBYTES FONT6432.DAT
TEMP:
 END

 
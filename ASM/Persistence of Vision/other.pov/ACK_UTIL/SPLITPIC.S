* Rip apart a DEGAS ELITE unpacked screen.

	bra	skip
source	incbin	"a:\master.pi1",0
	even
destin_pal	dc.b	"a:\pal.dat",0
	even
destin_dat	dc.b	"a:\data.dat",0
	even

skip	bsr	set_super
	dc.w	$a00a
	bsr	get_screen_base
	bsr	get_old_palette
	bsr	set_new_palette
	bsr	get_original_rez
	bsr	set_low_rez
	move.l	screen_base,a1
	lea	source+34,a0
	move.w	#32000/4-1,d0
.loop	move.l	(a0)+,(a1)+
	dbf	d0,.loop

	pea	insert
	move.w	#9,-(sp)
	trap	#1
	addq.l	#6,sp
	bsr	get_key

;create new file
	lea	destin_pal,a0
	bsr	f_create
	move.w	#34,d0
	lea	source,a0
	bsr	f_write
	bsr	f_close

	lea	destin_dat,a0
	bsr	f_create
	move.w	#32000,d0
	lea	source+34,a0
	bsr	f_write
	bsr	f_close

	bsr	set_old_palette
	bsr	set_med_rez
	dc.w	$a009
	bsr	set_user

	MOVE.W	#$0,-(SP)	; RETURN TO GEM DESKTOP.
	TRAP	#1
	RTS

***********************
* SUBROUTINES SECTION *
***********************

f_create:
	move.w	#0,-(sp)
	move.l	a0,-(sp)
	move.w	#$3c,-(sp)
	trap	#1
	add.l	#8,sp
	move.w	d0,handle
	rts

f_write:
	move.l	a0,-(sp)
	move.l	d0,-(sp)
	move.w	handle,-(sp)
	move.w	#$40,-(sp)
	trap	#1
	add.l	#12,sp
	rts

f_close:
	move.w	handle,-(sp)
	move.w	#$3e,-(sp)
	trap	#1
	addq.l	#4,sp
	rts

pause:	move.w	d0,-(sp)
	move.w	#5000,d0
pau:	nop
	dbf	d0,pau
	move.w	(sp)+,d0
	rts

get_key:
	move.w	#7,-(sp)
	trap	#1
	addq.l	#2,sp
	rts

set_super:
	clr.l	-(sp)		;Set super stack equal
	move.w	#$20,-(sp)	; to user stack before call
	trap	#1
	addq.l	#6,sp		;correct stack
	move.l	d0,stack_save	;save old supervisor stack value
	rts
set_user:
	move.l	stack_save,-(sp)
	move.w	#$20,-(sp)
	trap	#1		;back to user
	addq.l	#6,sp		;correct stack
	rts

get_old_palette:
	move.w	#8-1,d0
	lea	$ff8240,a0
	lea	old_palette,a1
get_old:
	move.l	(a0)+,(a1)+
	dbf	D0,get_old
	rts

set_new_palette:
	lea	source+2,a0
	bra	set_pal
set_old_palette:
	lea	old_palette,a0
set_pal:
	lea	$ff8240,a1
	move.w	#8-1,d0
set_p:	move.l	(a0)+,(a1)+
	dbf	d0,set_p
	rts

get_screen_base:
	move.w	#3,-(sp)
	trap	#14
	addq.l	#2,sp
	move.l	d0,screen_base
	rts

get_original_rez:
	move.w	#4,-(sp)
	trap	#14
	addq.l	#2,sp
	move.w	d0,original_rez
	rts

set_low_rez:
	clr.w	-(sp)
	bra	set_rez
set_med_rez:
	move.w	#1,-(sp)
set_rez:
	move.l	#-1,-(sp)
	move.l	#-1,-(sp)
	move.w	#5,-(sp)
	trap	#14
	add.l	#12,sp
	rts

****************
* DATA SECTION *
****************
stack_save:	dc.l	0
screen_base	dc.l	0
original_rez:	dc.w	0
handle:		dc.w	0
old_palette:	ds.w	16
	even
insert	dc.b	27,'Y',32+14,32+8,"** PRESS A KEY TO SAVE **",0
	even

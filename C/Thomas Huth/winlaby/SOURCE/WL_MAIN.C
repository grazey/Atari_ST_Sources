/********************************************************************/
/*				  		Das WindowLabyrinth							*/
/*					written by Thomas Huth, 1995-1997 				*/
/*------------------------------------------------------------------*/
/* See Readmes for more information.								*/
/* Set tabulator size to 4 !										*/
/********************************************************************/

#include <stdio.h>
#include <string.h>
#include <aes.h>
#include <vdi.h>
#include "winlaby.h"

int work_in[11], work_out[57];	/* F�r Openvwk */
int ap_id;						/* Applikationsnummer */
int vhandle;					/* VDI - Handle */
int msgbuff[8]; 				/* Message-Buffer */
int xy[10]; 					/* Feld f�r VDI-Malfunktionen */

int wi_handle;					/* Window-Handle */
GRECT wnd;						/* Fensterkoordinaten */
void *tree_adr; 				/* Adressvariable f�r's Pulldownmen� */
int deskx, desky, deskw, deskh; /* Desktopgr��e */

int richtung=2; 				/* Himmelsrichtung, in die man schaut */
int xpos,ypos;					/* Koordinaten des Spielers */
int zielx,ziely;				/* Koordinaten des Ziels */
int pmode=1;					/* 1=Leer zeichnen, 2=gef�llt */
unsigned char orttyp[21][21];	/* Feld f�r's Labyrinth  */

char inf_richtung[31]=" Richtung: X    Distanz: 	 "; /* String f�r Infozeile */

int redrawflag=FALSE;			/* Flag, ob neu gezeichnet werden soll */
int exitflag=FALSE;				/* If TRUE then exit */
int winnerflag=FALSE;			/* TRUE if you won the game */

/* Prototypen: */
int GEMinit(void);
void GEMexit(void);
int init_window(void);
void draw_laby(void);


/* ****Fehlermeldungausgabe**** */
void fehler(unsigned char *text)
{
 form_alert(1,text);
 v_clsvwk(vhandle); 		/* Virtuelle abmelden	*/
 appl_exit();
}


/* ****Men�wahl auswerten**** */
void menue(int auswahl)
{
 switch(auswahl)
  {
   case LABINFO:
	 form_alert(1,"[1][Das WindowLabyrinth V1.1!|Geschrieben von|Thomas Huth, 1995-97][ OK ]");
	 break;
   case NEU:
	 form_alert(1,"[3][Wie du willst:|Zur�ck zum Start!][Auf ein Neues]");
	 redrawflag=TRUE;
	 break;
   case ENDE:
	 form_alert(1,"[0][   Bis|  bald!   | ][ OK ]");
	 exitflag=TRUE;
	 break;
   case LABMODUS:
	 pmode=form_alert(pmode, "[2][Welche Darstellungsart?][leer|gef�llt]");
	 break;
  }
}


/* ****Grobe Wurzelfunktion**** */
int wurzel(int zahl)
{
 int i=0;
 if(zahl<0)  return(-1);
 for(i=0;i*i<zahl;i++)
  ;
 return(i);
}


/* ****Auf Tastendruck reagieren bzw. Spieler bewegen**** */
void walk(unsigned int keycode)
{
 unsigned char scancode, asciicode;

 scancode=(char)( (keycode>>8) & 0xFF );
 asciicode=(char)( keycode & 0xFF );

 if(asciicode=='8' || scancode==0x48)					/* Vorw�rts gehen */
  {
	if(richtung==1 && orttyp[xpos][ypos-1]!=1)	--ypos;
	if(richtung==2 && orttyp[xpos+1][ypos]!=1)	++xpos;
	if(richtung==3 && orttyp[xpos][ypos+1]!=1)	++ypos;
	if(richtung==4 && orttyp[xpos-1][ypos]!=1)	--xpos;
  }

 if(asciicode=='2' || scancode==0x50)
  {
	if(richtung==1 && orttyp[xpos][ypos+1]!=1)	++ypos;
	if(richtung==2 && orttyp[xpos-1][ypos]!=1)	--xpos;
	if(richtung==3 && orttyp[xpos][ypos-1]!=1)	--ypos;
	if(richtung==4 && orttyp[xpos+1][ypos]!=1)	++xpos;
  }

 if(asciicode=='4' || scancode==0x4B)	/* Drehung nach links, Taste "4"  */
	richtung=richtung-1;
 if(richtung==0)	richtung=4;

 if(asciicode=='6' || scancode==0x4D)	/* Drehung nach rechts, Taste "6" */
	richtung=richtung+1;
 if(richtung==5)	richtung=1;
}


/* ****Irrgarten laden**** */
int labload(void)
{
 FILE *file_ptr;			  /* Datei-Handle  */
 unsigned char readtext;	  /* Dummy f�r's Dateilesen */
 int x,y;
 static char labname[]="laby00.lab";

 if( ++labname[5] > '9' )
  {
   labname[5]='0';
   if( ++labname[4] > '9' )
	return(-1);
  }

 file_ptr=fopen(labname,"r");
 if(file_ptr==NULL)  return(49);
 for(y=1; y<21; y++)
  {
	for(x=1; x<21; x++)
	{
	 readtext=(unsigned char) fgetc(file_ptr);
	 if(readtext=='#') orttyp[x][y]=1; else orttyp[x][y]=0;
	 if(readtext=='Z') { orttyp[x][y]=0; zielx=x; ziely=y; }
	 if(readtext=='S') { orttyp[x][y]=0; xpos=x; ypos=y; }
	}
	do readtext=(unsigned char) fgetc(file_ptr);  while(readtext!='\n');
  }
 fclose(file_ptr);
 return(0);
}


/* ***** UND LOS GEHT'S ! ***** */
int main(void)
{
 int dummy; 				/* Dummyvariable */
 int *d=&dummy; 			/* Dummyzeiger	 */
 int lab_nr=1;				/* Nummer des Labyrinths */
 int taste; 				/* F�r Eingaben  */
 GRECT clp;					/* F�r Werte aus der Rechtecksliste */
 int whichevnt; 			/* Welches Ereignis eintritt */

 if( GEMinit() ) return(-1);	/* GEM anmelden */

 if( labload() )				/* 1. Laby laden */
  {
   form_alert(1, "[3][Konnte 1. Laby|nicht laden.][Abbruch]");
   GEMexit();
   return(-1);
  }

 if(init_window()!=0)
	return(-1);

 /*--- Und ab ins Labyrinth ---*/
 do
 {

  /* Infozeile erstellen */
  switch(richtung)
  {
	case 1: inf_richtung[11]='N'; break;
	case 2: inf_richtung[11]='O'; break;
	case 3: inf_richtung[11]='S'; break;
	case 4: inf_richtung[11]='W'; break;
  }
  dummy=(zielx-xpos)*(zielx-xpos)+(ziely-ypos)*(ziely-ypos);
  itoa(wurzel(dummy), &inf_richtung[25], 10);
  wind_set(wi_handle, WF_INFO, inf_richtung, 0L);  /* Richtung anzeigen */

  /* Auf Eingaben warten */
  whichevnt=evnt_multi(MU_MESAG|MU_KEYBD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						msgbuff, 0, 0, d, d, d, d, &taste, d);

  /* Wenn Taste gedr�ckt, dann bewegen */
  if(whichevnt & MU_KEYBD)
   {
	walk(taste);
	redrawflag=1;
   }

  /* Auf Ereignisse reagieren */
  if(whichevnt & MU_MESAG)
   switch(msgbuff[0])
	{
	 case WM_SIZED: 						/* Fenstergr��e �ndern */
		 redrawflag=TRUE;
	 case WM_MOVED:
		 wind_set(msgbuff[3], WF_CURRXYWH, msgbuff[4], msgbuff[5],
				  msgbuff[6], msgbuff[7]);
		 break;
	 case WM_FULLED:						/* Fenster auf Maximalgr��e */
		 wind_set(msgbuff[3], WF_CURRXYWH, deskx, desky, deskw, deskh);
		 break;
	 case WM_TOPPED:						/* Fenster toppen */
		 wind_set(msgbuff[3], WF_TOP, 0L, 0L);
		 break;
	 case WM_REDRAW:
		 redrawflag=TRUE;
		 break;
	 case WM_CLOSED:
		 exitflag=TRUE;
		 break;
	 case MN_SELECTED:						/* Men� */
		 menu_tnormal(tree_adr, msgbuff[3], 1);
		 menue(msgbuff[4]);
		 if(msgbuff[4]==NEU)  { xpos=2; ypos=2; }
		 if(msgbuff[4]==LABMODUS)	redrawflag=1;
		 break;
	}

  /*--- Neues Labyrinth laden ---*/
  if(xpos==zielx && ypos==ziely)
   {
	form_alert(1,"[1][Dieses Labyrinth w�re|�berstanden.|Auf ins n�chste!][ OK ]");
    dummy=labload();
	if(dummy<0)		{ GEMexit(); return(-1); }
	if(dummy==49)	{ exitflag=TRUE; winnerflag=TRUE; }
	++lab_nr;
   }

  /* --- Labyrinth zeichnen --- */
  wind_get(wi_handle, WF_WORKXYWH, &wnd.g_x, &wnd.g_y, &wnd.g_w, &wnd.g_h); /* Fensterparameter */
  if(redrawflag)					/* Neu zeichnen ? */
   {
	redrawflag=0;
	wind_update(BEG_UPDATE);		/* Bildaufbau Anfang */
	graf_mouse(M_OFF, 0L);			/* Maus aus */
	wind_get(wi_handle, WF_FIRSTXYWH, &clp.g_x, &clp.g_y, &clp.g_w, &clp.g_h);
	while(clp.g_w && clp.g_h)		/* Solange noch Rechtecke in der Liste sind */
	 if( rc_intersect(&wnd, &clp) )
	  {
	   clp.g_w+=clp.g_x-1;	clp.g_h+=clp.g_y-1;
	   vs_clip(vhandle, 1, &clp);	/* Clipping setzen */
	   draw_laby();					/* Teil des Labys zeichnen */
	   wind_get(wi_handle, WF_NEXTXYWH, &clp.g_x, &clp.g_y, &clp.g_w, &clp.g_h);
	  }
	graf_mouse(M_ON, 0L);			/* Maus an */
	wind_update(END_UPDATE);		/* Bildaufbau Ende */
   }

 }
 while(!exitflag);

 /*--- Programm verlassen ---*/

 wind_close(wi_handle); 				/* Window schlie�en */
 wind_delete(wi_handle);				/* Window abmelden	*/

 if(winnerflag)
  form_alert(1,"[1][Gratuliere, du hast|alle Irrg�rten|durchwandert!][ YEAH! ]");

 GEMexit();
}

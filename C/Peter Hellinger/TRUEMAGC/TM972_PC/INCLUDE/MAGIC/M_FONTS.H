/*
   Modul: M_FONTS.C (Headerdatei)

   geschrieben von Thomas K�nneth
   Friedrich-Neuper-Str. 2b
   90552 R�thenbach

   Diese Datei ist Bestandteil der C-Version von Magic 4.0 von
   Peter Hellinger und Thomas K�nneth und darf nur gem�� den
   Nutzungsbedingungen von Magic f�r C verwendet werden

   Alle Rechte beim Autor
*/

#ifndef _MPFONTS_
#define _MPFONTS_

#define ErrNoFonts      0    /* Keine Fonts geladen  */
#define ErrNoGdos      -1    /* Kein GDOS            */
#define ErrLessMem     -2    /* Kein Speicher        */
#define ErrWorkstation -3    /* Workstation nicht �ber mpAppl ge�ffnet */

#define FFIRST  0
#define FNEXT   1
#define FPREV   2
#define FLAST   3

typedef struct
{
   char     name[52];      /* Name des Fonts */
   int      id;            /* Font-ID */
   int      color;         /* Farbindex */
   int      rot;           /* Rotationsrichtung */
   int      halign;        /* Horizontale Ausrichtung */
   int      valign;        /* Vertikale Ausrichtung */
   int      chw;           /* Zeichenbreite */
   int      chh;           /* Zeichenh�he */
   int      boxw;          /* Zellenbreite */
   int      boxh;          /* Zellenh�he */
   BITSET   effect;        /* Texteffekte */
   int      min;           /* Minimale Gr��e des Fonts */
   int      max;           /* Maximale Gr��e des Fonts */
   int      point;         /* aktuelle Gr��e des Fonts */
   int      width;         /* Breite bei FSM-Fonts */
   int      skew;          /* Neigung bei FSM-Fonts */
   int      typ;           /* Fonttyp */
   BITSET   flags;         /* Bit0 = Font Monospaced */
} tFontinfo;

#define NoError        0
#define CharNotFound   1
#define ReadError      8
#define OpenError      9
#define BadFileformat 10
#define OutOfMemory   11
#define MiscError     -1

/* Bits f�r tFontinfo.flags */
#define cfMono         1

int LoadFonts(int handle,BOOLEAN message);
int FontsLoaded(int handle);
void UnloadFonts(int handle);
int FontList(int handle,int flag);
BOOLEAN FontAvailable(int handle,int fontid);
void FontInfo(int handle,int font,tFontinfo *info);
void UpdateFontInfo(int handle,tFontinfo *info);
int FontActive(int handle);
void FontSelect(int handle,int font,BOOLEAN actual);
int FontSize(int handle,int point,int *chw,int *chh,int *boxw,int *boxh);
int FontDefsize(int handle);
int NextBigger(int handle);
int NextSmaller(int handle);
void FontColor(int handle,int color);
void FontEffect(int handle,BITSET effekt);
int FontRotate(int handle,int angle);
void FontWidth(int handle,int width);
void FontSkew(int handle,int skew);
void FontExtent(int handle,char *str,tPxyRect *rect);
int FontError(void);

#endif
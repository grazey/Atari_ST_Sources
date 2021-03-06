/*
   Modul: M_FONTSE.C (Headerdatei)

   geschrieben von Thomas K�nneth
   Friedrich-Neuper-Str. 2b
   90552 R�thenbach

   Diese Datei ist Bestandteil der C-Version von Magic 4.0 von
   Peter Hellinger und Thomas K�nneth und darf nur gem�� den
   Nutzungsbedingungen von Magic f�r C verwendet werden

   Alle Rechte beim Autor
*/

#ifndef _MPFONTSE_
#define _MPFONTSE_

#ifndef _MAGICTYP_
#include <magic\m_types.h>
#endif

#define fsFlydial      lBit0  /* Normaler Dialog                 */
#define fsModal        lBit1  /* Selektor in Fenster             */
#define fsNonmodal     lBit2  /* Selektor ist nicht-modal        */
#define fsMonospaced   lBit3  /* monospaced Fonts als Default    */
#define fsEffect       lBit4  /* Texteffekte ausw�hlen           */
#define fsColor        lBit5  /* Farbe ausw�hlen                 */
#define fsRotation     lBit6  /* Rotation einstellen             */
#define fsWidth        lBit7  /* Breite bei FSM-Fonts einstellen */
#define fsSpeedoOnly   lBit8  /* Nur Speedofonts anzeigen        */
#define fsBitmapOnly   lBit9  /* Nur Bitmapfonts anzeigen        */
#define fsTruetypeOnly lBit10 /* Nur Truetypefonts anzeigen      */
#define fsType1Only    lBit11 /* Nur Type1-Fonts anzeigen        */
#define fsFixType      lBit12 /* Typselektion nicht zulassen     */
#define fsOwntext      lBit13 /* Eigenen Text in der Auswahlbox  */

#define CloseSelector()  CallMagic(1501)
#define RedrawSelector() CallMagic(1503)

void FontSelector(int handle,char *msg,BITSET opt);
void SampleSentence(char* txt);
void SelectorInfo(int *win, int *xpos, int *ypos, int *font);

#endif

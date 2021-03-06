/*
   M_XTRNL.H

   geschrieben von Thomas K�nneth
   Friedrich-Neuper-Str. 2b
   90552 R�thenbach

   Diese Datei ist Bestandteil der C-Version von Magic 4.0 von
   Peter Hellinger und Thomas K�nneth und darf nur gem�� den
   Nutzungsbedingungen von Magic f�r C verwendet werden

   Alle Rechte beim Autor
*/

#ifndef _EXTERNAL_
#define _EXTERNAL_

extern   int         ApplIdent      ; /* Application-ID des Programms        */
extern   int         AESFontid      ; /* Fontid der AES-Workstation          */
extern   int         AESFontsize    ; /* Defaultsize des AES-Fonts in Pixel  */
extern   int         CharWidth      ; /* Zeichenbreite der AES-Workstation   */
extern   int         CharHeight     ; /* Zeichenh�he der AES-Workstation     */
extern   int         BoxWidth       ; /* Boxbreite der AES-Workstation       */
extern   int         BoxHeight      ; /* Boxh�ehe der AES-Workstation        */
extern   int         DeskX          ; /* X-Position des Desktop-Fensters     */
extern   int         DeskY          ; /* Y-Position des Desktop-Fensters     */
extern   int         SmallFontid    ; /* Id des Iconfonts */
extern   int         SmallFontsize  ; /* Gr�sse in Punkt des Iconfonts */
extern   int         SmallChWidth   ; /* Zeichenbreite */
extern   int         SmallChHeight  ; /* Zeichenh�he */
extern   int         SmallBoxWidth  ; /* Boxbreite */
extern   int         SmallBoxHeight ; /* Boxh�he */
extern   BOOLEAN     SpeedoGDOS     ; /* TRUE, wenn Speedo da ist */
extern   int         SpeedoVersion  ; /* Versionsnummer von Speedo */
extern   BOOLEAN     NVDIGDOS       ; /* TRUE, wenn NVDI da ist */
extern   int         NVDIVersion    ; /* Versionsnummer von NVDI */
extern   BOOLEAN     XMenuPossible  ; /* TRUE, wenn die extended menus verf�gbar sind */
extern   BOOLEAN     IconifyPossible; /* TRUE, wenn Iconify m�glich ist */
extern   BOOLEAN     UpdatePossible ; /* TRUE, wenn wind_update check&set funktioniert */
extern   BITSET      WindowFunction ; /* Verf�gbare zus�tzliche Fensterfunktionen, */
extern   BITSET      WindowElements ; /* wie sie von appl_getinfo geliefert werden */
extern   GRECT       ScreenRect     ;
extern   GRECT       Win0Rect       ;
extern   BOOLEAN     Multitask      ;
extern   BOOLEAN     KaosTos        ;
extern   BOOLEAN     MiNTInstalled  ;
extern   long        MiNTVersion    ;
extern   WORKSTATION DefaultWS      ; /* Info der ge�ffneten Workstation  */
extern   int         AESVersion     ; /* die Versionsnummer der AES */
extern   PtrApp      Appl           ;

#endif

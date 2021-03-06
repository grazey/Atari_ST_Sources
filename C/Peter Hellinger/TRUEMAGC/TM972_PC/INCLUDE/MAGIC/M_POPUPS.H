/*
   Modul: M_POPUPS (Headerdatei)

   geschrieben von Thomas K�nneth
   Friedrich-Neuper-Str. 2b
   90552 R�thenbach

   Diese Datei ist Bestandteil der C-Version von Magic 4.0 von
   Peter Hellinger und Thomas K�nneth und darf nur gem�� den
   Nutzungsbedingungen von Magic f�r C verwendet werden

   Alle Rechte beim Autor
*/

#ifndef _MPPOPUPS_
#define _MPPOPUPS_

#ifndef _MAGICTYP_
#include <magic\m_types.h>
#endif

void AttachPopup(OBJECT *main,OBJECT *sub,int entry);
void Popup(OBJECT *tree,int x,int y,int idx,OBJECT **pop,int *item);

#endif
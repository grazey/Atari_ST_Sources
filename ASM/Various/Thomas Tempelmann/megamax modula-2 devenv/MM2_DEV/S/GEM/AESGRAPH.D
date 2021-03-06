DEFINITION MODULE AESGraphics;


(*  Megamax Modula-2 GEM-Library :  Die AES Grafikfunktionen
 *
 *  Autor: Manuel Chakravarty           Erstellt :  05.11.87
 *
 *  Version   2.2     V#0011
 *)
 
 
FROM GrafBase   IMPORT Point, Rectangle, PtrMouseFormDef;

FROM GEMGlobals IMPORT MButtonSet, SpecialKeySet, OStateSet, PtrObjTree;
 
 
                        (*  Graphic Manager  *)
                        (*  ===============  *)
                
                
PROCEDURE RubberBox (start: Rectangle; VAR loc: Point);

        (*  Ein vom Benutzer ver�nderbarer Rahmen wird auf dem Bildschirm
         *  animiert.
         *
         *  'start' gibt die minimalen Rahmenausma�e und dessen Position
         *  an. Zum Zeitpunkt des Aufrufs dieser Routine mu� die linke
         *  Maustaste gedr�ckt sein. Die Routine kehrt zur�ck, sobald die
         *  Taste losgelassen wurde. In 'loc' wird die Ausdehnung des Rah-
         *  mens (Breite und H�he) zum Zeitpunkt des Loslassens der Maus-
         *  taste geliefert.
         *)
        
PROCEDURE DragBox (start, bound: Rectangle; VAR loc: Point);

        (*  Ein vom Benutzer verschiebarer Rahmen wird auf dem Bildschirm
         *  animiert.
         *
         *  Eingabeparameter:
         *  -----------------
         *
         *  'start'  -- Ausma�e und Startposition des beweglichen Rahmens.
         *  'bound'  -- Ausma�e und Position der Bildschirmfl�che, inner-
         *              halb derer der Rahmen bewegt werden kann.
         *
         *  Ausgabeparamter:
         *  ----------------
         *
         *  'loc'    -- Position des Rahmens beim Loslassen des linken Maus-
         *              taste.
         *
         *  Die linke Maustaste mu� beim Aufruf der Routine gedr�ckt sein.
         *  Sie kehrt zur�ck, sobald die Taste losgelassen wird.
         *)
        
PROCEDURE MoveBox (orgin: Rectangle; dest: Point);

        (*  Es wird ein sich bewegender Rahmen animiert.
         *
         *  Eingabeparameter
         *  ----------------
         *
         *  'origin'    -- Startposition und Ausma�e dews Rahmens
         *  'dest'      -- Zielpunkt des Rahmens
         *)
 
PROCEDURE GrowBox (orgin, dest: Rectangle);

        (*  Es wird ein Rahmen gezeichnet der von 'orgin' nach
         *  'dest'  anw�chst.
         *)

PROCEDURE ShrinkBox (orgin, dest: Rectangle);

        (*  Der sich von 'orgin' nach 'dest' bewegende Rahmen schrumpft.
         *)
         
PROCEDURE WatchBox (    tree             : PtrObjTree;
                        index            : CARDINAL;
                        inState, outState: OStateSet;
                    VAR inside           : BOOLEAN);
                   
        (*  Diese Routine �berwacht die Maus daraufhin, ob sich der Maus-
         *  zeiger beim Loslassen der linken Taste innerhalb oder au�er-
         *  halb eines bestimmten Objekts befindet.
         *
         *  Eingabeparameter
         *  ----------------
         *
         *  'index'     -- Das Objekt mit diesem Index mu� bereits Teil
         *                 des Objektbaumes sein und sich auf dem Bild-
         *                 schirm befinden.
         *  'tree'      -- Gibt den Objektbaum an.
         *  'inState'   -- Bezeichnet den Status, den das Objekt an-
         *                 nehmen soll solange sich der Mauszeiger
         *                 innerhalb des Objekts befindet.
         *  'outState'  -- ..au�erhalb des Objekts befindet.
         *
         *  Ausgabeparameter
         *  ----------------
         *
         *  'inside'    -- 'TRUE' : die linke Maustaste wurde losge-
         *                 lassen w�hrend sich der Zeiger innerhalb
         *                 des Objekts befand.
         *
         *  Beim Aufruf sollte der linke Mausknopf gedr�ckt sein, da
         *  da die Routine beim Loslassen des Knopfes verlassen wird.
         *)
         
         
TYPE    SlideDirection  = (horSlide, vertSlide);
        
PROCEDURE SlideBox (tree         : PtrObjTree;
                    parent, child: CARDINAL;
                    dir          : SlideDirection;
                VAR newPos       : CARDINAL);
                   
        (*  Diese Prozedur kontrolliert die Bewegung eines Schiebereglers.
         *
         *  Eingabeparameter
         *  ----------------
         *
         *  'child'     -- dieses Objekt kann innerhalb des Objekts
         *  'parent'    -- verschoben werden. Sie m�ssen beide auf dem
         *                 Bildschirm sichtbar sein.
         *  'tree'      -- Sowohl 'child' als auch 'parent' mu� Element
         *                 des Objektbaumes sein, wobei 'child' in der
         *                 Baumstruktur Nachfolger von 'parent' sein mu�.
         *  'dir'       -- Legt fest, ob die horizontale oder die ver-
         *                 tikale Bewegung des Reglers �berwacht werden
         *                 soll.
         *
         *  Ausgabeparameter
         *  ----------------
         *
         *  'newPos'    -- Gibt die relative Position des Reglers beim
         *                 Loslassender linken Maustaste im Bereich
         *                 zwischen 0 und 1000 in Promille an.
         *
         *  Die linke Maustaste sollte beim Aufruf gedr�ckt sein !
         *)
        

        (*  'bee' entspricht dem 'hourglass' andere GEM-Library's, der
         *  ST stellt aber eine Biene und keine Uhr dar, wie es z.B.
         *  beim IBM-GEM der Fall ist.
         *)
TYPE    MouseForm       = (arrow, textCursor, bee, pointHand, flatHand,
                           thinCross, thickCross, outlineCross, userCursor,
                           mouseOff, mouseOn);
       

PROCEDURE GrafMouse (form: MouseForm; mouseFormPtr: PtrMouseFormDef);

        (*  Hiermit kann das Aussehen des Mauscursors ver�ndert werden.
         *
         *  Zum einen stehen einige vordefiniert Zeigerformen zur ver-
         *  f�gung, zum anderen kann man bei der Wahl von 'userCursor'
         *  in dem zweiten Parameter 'mFormDefPtr' einen Zeiger auf
         *  eine eigene Mausform angegeben (siehe 'GrafBase').
         *  Letztlich kann man mit 'mouseOff' erreichen, da� der Cursor
         *  versteckt wird und ihn mit 'mouseOn' wieder sichtbar machen.
         *  Bei sukzessivem Verstecken des Mauszeigers, mu� er auch ge-
         *  nauso oft wieder sichtbar gemacht werden.
         *)
         
PROCEDURE MouseKeyState (VAR mouseLoc  : Point;
                         VAR mouseButs : MButtonSet;
                         VAR keys      : SpecialKeySet);
                        
        (*  Erfragt den Zustand von Maus und Tastatur.
         *
         *  Ausgabeparameter
         *  ----------------
         *
         *  'mouseloc'  -- Position des Mauszeigers.
         *  'mouseButs' -- Zustand der Maustasten.
         *  'key'       -- Zustand der Tastatursondertasten.
         *)
         
         
END AESGraphics.
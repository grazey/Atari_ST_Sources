DEFINITION MODULE SysUtil2;

(*
 * SetJump/LongJump (globales GOTO), sowie Funktionen zum Erlangen des
 * Supervisormodus und Kontrolle der Interruptlevel-Maske.
 *
 * 07.12.88  TT  Grunderstellung
 * 13.06.90  TT  'SupervisorMode'/'UserMode' in 'EnterSupervisorMode'
 *               und 'LeaveSupervisorMode' umbenannt, 'InSupervisorMode' neu.
 *)


FROM SYSTEM IMPORT WORD, ADDRESS, LONGWORD;

(*
 * C-artige 'SetJmp' / 'LongJmp'
 * -----------------------------
 *
 *   Diese aus der Sprache C bekannten Funktionen stellen ein "globales"
 * GOTO dar. 'SetJump' deklariert ein "Label" und 'LongJump' f�hrt den
 * Sprung aus. Die Verwendung dieser Funktionen ist v.A. f�r Fehlerbehand-
 * lungen sehr n�tzlich. So kann beispielsweise von einem tief verschachtel-
 * ten Prozeduraufruf direkt zur�ck auf h�her gelegenes Level zur�ckge-
 * sprungen werden.
 *   Zu beachten ist dabei, da� nie von einer "h�heren" in eine "tiefer"
 * verschachtelte Funktion gesprungen werden darf (z.B. von einer Prozedur
 * in ihre lokale), da in einem solchen Fall der dazwischen notwendige
 * Initialisierungsteil f�r die lokalen Daten fehlen w�rde. In der anderen
 * Richtung werden lediglich alle lokalen Daten "weggeworfen", �hnlich der
 * RETURN-Anweisung bei Modula-2.
 *
 * Beispiel:
 *
 *  VAR ljbuf1: JumpBuf;
 *  PROCEDURE zwei;
 *    PROCEDURE lokal;
 *      BEGIN
 *         IF fehler1 () THEN LongJump (ljbuf1, 1) END;
 *      END lokal;
 *    BEGIN (* von 'zwei' *)
 *      lokal;
 *      IF fehler2 () THEN LongJump (ljbuf1, 2) END;
 *    END zwei;
 *  PROCEDURE haupt;
 *    BEGIN
 *      CASE SetJump (ljbuf1) OF
 *        0: (* Label wurde deklariert -> 'zwei' aufrufen: *)
 *           zwei;
 *           (* 'zwei' kehrte ohne Fehler zur�ck *)
 *           zeige ('Kein Fehler.')
 *      | 1: zeige ('Fehler in Prozedur "lokal" !')
 *      | 2: zeige ('Fehler in Prozedur "zwei" !')
 *      END;
 *    END haupt;
 *
 * Im Beispiel wird zuerst 'haupt' ausgef�hrt. Diese installiert die Sprung-
 * marke 'ljbuf1' und ruft dann 'zwei' auf. Jene Prozedur ruft 'lokal' auf,
 * welche dann eine Operation durchf�hrt, die ggf. einen R�cksprung zur
 * 'SetJump'-Anweisung ausf�hrt. Ist dies nicht der Fall, kann ebenso, nach
 * R�ckkehr zu 'zwei' diese Prozedur einen R�cksprung ausl�sen - im Gegensatz
 * zum 'LongJump'-Aufruf in 'lokal' wird hier aber zur Kontrolle ein anderer
 * Wert (2) zur�ckgeliefert. Wird auch dieser 'LongJump'-Aufruf nicht durch-
 * gef�hrt, kehrt 'zwei' normal zu 'haupt' zur�ck, wo "kein Fehler" signali-
 * siert wird. In den anderen F�llen wird zu den anderen CASE-Marken gesprun-
 * gen und ein entsprechender Fehler signalisiert.
 *)

TYPE JumpBuf = RECORD
                 pc: ADDRESS;
                 ssp: LONGWORD;
                 usp: LONGWORD;
                 sr: WORD;
                 d: ARRAY [1..7] OF LONGWORD;
                 a: ARRAY [1..6] OF LONGWORD;
               END;

PROCEDURE SetJump ( VAR hdl: JumpBuf ): INTEGER;
  (*
   * Setzt eine "globale" R�cksprungmarke.
   * Das bedeutet, da� diese Prozedur nach ihrem Aufruf den Wert Null liefert.
   * Wird dann sp�ter 'LongJump' (s.u.) mit demselben 'hdl' aufgerufen, wird
   * das Programm wiedrum hinter 'SetJump' weitergef�hrt, wobei diese Proze-
   * dur einen von Null verschiedenen Wert liefern wird.
   *)

PROCEDURE LongJump ( VAR hdl: JumpBuf; rtnCode: INTEGER );
  (*
   * F�hrt einen R�cksprung zum Aufruf der zu 'hdl' geh�renden 'SetJump'-
   * Funktion durch. 'SetJump' liefert dabei 'rtnCode'. 'rtnCode' darf nicht
   * Null sein - ist dies trotzdem der Fall, wird stattdessen 1 geliefert.
   *
   * Restauriert D3-D7, A3-A7, PC und SR (incl. User-/Superv.-Modus und IRMask)
   *)

(*
 * Enter/LeaveSupervisorMode
 * -------------------------
 *   zum Erlangen des Supervisor-Modus und R�ckkehr in den User-Modus.
 * Nur im Supervisor-Modus lassen sich bestimmte Operationen durchf�hren,
 * wie z.B. der Zugriff auf die Systemvariablen auf den Adressen zw. $400
 * und $800 (gerade f�r solche Zugriffe bieten sich aber eher die Peek-
 * und Poke-Funktionen aus dem Modul 'SysUtil1' an!).
 * Auch kann alternativ die Funktion 'Calls.CallSupervisor' verwendet werden.
 *
 * Als Stack wird der aktuelle User-Stack verwendet.
 *)

TYPE ModeBuf = LONGWORD;

PROCEDURE EnterSupervisorMode ( VAR hdl: ModeBuf );
PROCEDURE LeaveSupervisorMode ( VAR hdl: ModeBuf );
PROCEDURE InSupervisorMode (): BOOLEAN;
  (*
   * 'EnterSupervisorMode' darf auch im Supervisor-Modus aufgerufen werden,
   * in dem Fall �ndert sich nichts.
   * Ein 'LeaveSupervisorMode'-Aufruf nur nach vorherigem Aufruf von
   * 'EnterSupervisorMode' erfolgen!
   * Beide Aufrufe m�ssen auf demselben "Scope-Level" erfolgen.
   * Das hei�t, da� sie nicht nur in der selben Prozedur, sondern auch auf
   * dem selben Einr�ckungs-Level erfolgen m�ssen (also z.B. nicht die eine
   * au�erhalb einer FOR- und die andere innerhalb dieser Schleife).
   *
   * 'InSupervisorMode()' liefert TRUE, wenn sich das Programm gerade im
   * Supervirsor-Modus befindet.
   *)

TYPE IRLevel = [0..7];

PROCEDURE SetIRMask ( level: IRLevel );
  (*
   * Setzt, unabh�ngig vom Modus (User- o. Supervisor), die Interruptlevel-
   * Maske (0-7).
   *)

PROCEDURE IRMask (): IRLevel;
  (*
   * Liefert den aktuellen Wert der IR-Level-Maske.
   *)

END SysUtil2.

DEFINITION MODULE ArgCV;

(* Wertet keine I/O-Umleitungsangabe (mit '<','>') in der Argumentzeile aus *)

TYPE ArgStr = ARRAY [0..127] OF CHAR;

     PtrArgStr = POINTER TO ArgStr;


PROCEDURE InitArgCV ( VAR ArgC : CARDINAL; VAR ArgV : ARRAY OF PtrArgStr );
  (*
   * 'ArgC' enth�lt nach dem Aufruf die Anzahl der initialisierten ArgV-Felder.
   * Das 'ArgV'-Feld sollte die Gr��e [0..ErlaubteArgumentAnzahl] haben.
   * 'ArgV[0]' ist immer ein Leerstring, 'ArgV[1]' enth�lt das erste Argument.
   * Das letzte g�ltige Argument steht demnach in 'ArgV[ArgC-1]'.
   *)

END ArgCV.

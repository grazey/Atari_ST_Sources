MODULE Trap0;
(* � 1996 by ROLF SCHRADER.      * 6.3.96 *)
(*$S-,$T-,$Q+*)
(*
   Macht nichts weiter, als durch den (normalerweise unbenutzten und darum
   mit RTE belegten) Trap Nr. 0 zu springen. Dabei sorgt dann allerdings der
   normale CEH daf�r, da� der Sprung seine Spur in der SaveArea auch sogar
   post mortem hinterl��t - und darum mit LastSigh, Err_Blur o.�. bequem
   abgefragt werden kann.
*)
FROM SYSTEM IMPORT CODE;

CONST TRAP = 4E40H;

BEGIN CODE (TRAP+0) END Trap0.

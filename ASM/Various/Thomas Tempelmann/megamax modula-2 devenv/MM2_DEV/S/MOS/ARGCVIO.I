IMPLEMENTATION MODULE ArgCVIO;

(*$Y+,R-,C-*)

FROM SYSTEM IMPORT ASSEMBLER, ADDRESS, WORD, BYTE, TSIZE;

FROM PrgCtrl IMPORT ActiveProcess;

FROM InOut IMPORT RedirectOutput, RedirectInput;


CONST MaxArgs = 63;

PROCEDURE InitArgCV ( VAR ArgC : CARDINAL; VAR ArgV : ARRAY OF PtrArgStr );

  VAR comlin : Address;
      i, quote : Cardinal;
      append, inword : Boolean;
      p: Address;
      new_stdin, new_stdout : PtrArgStr;

  (*$L-*)
  PROCEDURE Peek (p:Address) : CHAR;
    BEGIN
      ASSEMBLER
        MOVE.L  -(A3),A0
        CLR.W   D0
        MOVE.B  (A0),(A3)+
        ADDQ.L  #1,A3
      END
    END Peek;
  (*$L+*)
  
  (*$L-*)
  PROCEDURE Poke (p:Address;v:Byte);
    BEGIN
      ASSEMBLER
        SUBQ.L  #1,A3
        MOVE.B  -(A3),D0
        MOVE.L  -(A3),A0
        MOVE.B  D0,(A0)
      END
    END Poke;
  (*$L+*)
  
  PROCEDURE isspace (c:Char):Boolean;
    BEGIN
      RETURN (c=' ') OR (c=11c) OR (c=15c) OR (c=12c)
    END isspace;
  
  PROCEDURE newWd;
    BEGIN
      IF argc <= HIGH (argv) THEN
        ArgV[argc] := PtrArgStr(p);
      END;
      Inc (argc);
    END newWd;
  
  PROCEDURE tstQuote (n:CARDINAL);
    BEGIN
      IF quote = n THEN
        Poke (p,0C);
        quote := 0
      ELSIF ~inword & (quote=0) THEN
        Poke (p,0C);
        quote := n;
        newWd
      END
    END tstQuote;
  
  BEGIN
    new_stdin := Nil;
    new_stdout := Nil;
    inword := False;
    quote := 0;
    
    comlin:= ActiveProcess();
    Inc (comlin, 128);
    
    argc := 1;    (* always have at least program name *)
    
    p := comlin+1L;
    
    FOR i:= 1 TO ORD (Peek(comlin)) DO
        IF isspace(Peek(p)) THEN
            IF quote=0 THEN
                inword := False;
                Poke (p,0C)
            ELSE
                Poke (p,' ')
            END;
        ELSIF Peek(p) = '"' THEN
            tstQuote (1);
        ELSIF Peek(p) = "'" THEN
            tstQuote (2);
        ELSE
            IF ~inword & (quote=0) THEN
                inword := True;
                IF (Peek(p) = '<') THEN    (* redirect stdin *)
                    new_stdin := p+1L
                ELSIF (Peek(p) = '>') THEN
                    IF (Peek((p+1L)) = '>') THEN
                        new_stdout := p+2L;    (* redirect and append stdout *)
                        append := True
                    ELSE
                        new_stdout := p+1L; (* redirect stdout *)
                        append := False
                    END;
                ELSE
                    (* not redirection, add to argv[] *)
                    newWd
                END
            END
        END;
        Inc (p);
    END;
    Poke (p,0C);  (* make sure last string is null terminated *)
    
    i:=argc;
    WHILE i<=HIGH(argv) DO
      ArgV[i] := PtrArgStr(p);
      Inc (i)
    END;
    
    (* Open redirection files now *)
    IF new_stdin#Nil THEN
        RedirectInput (new_stdin^)
    END;
    IF new_stdout#Nil THEN
        RedirectOutput (new_stdout^,append)
    END;
    
    argv[0] := p;          (* no program name *)
    
  END InitArgCV;

END ArgCVIO.
 
(* $FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$00000209$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E$FFFD566E�$00000464T.......T.......T.......T.......T.......T.......T.......T.......T.......T.......$00000209$00000051$FFEDB15C$FFECCFDB$FFECCFDB$000000C8$00000464$00000481$00000468$FFEDB15C$FFEDB15C$00000027$00000084$FFEDD2CF$000005F7$00000606���*)

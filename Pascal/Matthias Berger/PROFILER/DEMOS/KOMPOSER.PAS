PROGRAM Computer_Composition; { 7. Bundeswettbewerb Informatik 1988/1989 }
                              { 1. Runde,Aufgabe 1 ; Autor M.Berger      }
                              {   Hinweise am Ende des Files beachten !  }

  
  CONST Max_Laenge_Motiv        = 20;
        Max_Anzahl_Toene        = 10;
        Max_Anzahl_Schritte     = 20;
  TYPE  Abbildungsregel_DEF     = RECORD
                                    Alt       : CHAR;
                                    Neu       : CHAR;
                                  END;
        Wandlungs_ART    = (Thema,Variation);
      
  VAR   Satzform                         : ARRAY[1..Max_Anzahl_Schritte] OF
                                                 Wandlungs_ART;
        Anzahl_Schritte                  : INTEGER;
        Abbildungsregel                  : ARRAY[1..Max_Anzahl_Toene] 
                                                 OF Abbildungsregel_DEF;
        Anzahl_Toene                     : INTEGER;
        Motiv                            : ARRAY[1..Max_Laenge_Motiv] OF
                                                CHAR;
        Motivlaenge                           : INTEGER;
        Prestofaktor                     : REAL;
        Anzahl_Saetze                    : INTEGER;
        Tondauer                         : REAL;
        i                                : INTEGER;
        
 PROCEDURE Eingabe;
   VAR i : INTEGER;
       x : CHAR;
   BEGIN
     CLRSCR;WRITELN('Computer-Composition  (bwINF 7 [88/89];Aufgabe 1)');
     WRITELN;WRITELN;
     
     Anzahl_Toene:=0;
     REPEAT
       Anzahl_Toene:=Anzahl_Toene+1;
       WRITE('  Bitte Ton angeben : ');
       READ(kbd,Abbildungsregel[Anzahl_Toene].Alt);
       WRITE(Abbildungsregel[Anzahl_Toene].Alt);
       IF Abbildungsregel[Anzahl_Toene].Alt<>' ' THEN
       BEGIN
         WRITE(' ; Wird abgebildet auf : ');
         READ(kbd,Abbildungsregel[Anzahl_Toene].Neu);
         WRITE(Abbildungsregel[Anzahl_Toene].NEU);
       END;
       WRITELN;
     UNTIL (Anzahl_Toene=Max_Anzahl_Toene) OR 
           (Abbildungsregel[Anzahl_Toene].Alt=' ');
     Anzahl_Toene:=Anzahl_Toene-1;
     WRITELN;
     
     Motivlaenge:=0;
     REPEAT
       Motivlaenge:=Motivlaenge+1;
       WRITE('  Bitte Ton des Themas angeben : ');
       READ(kbd,Motiv[Motivlaenge]);WRITELN(Motiv[Motivlaenge]);
     UNTIL (Motiv[Motivlaenge]=' ') OR (Motivlaenge>Max_Laenge_Motiv);
     Motivlaenge:=Motivlaenge-1;
     WRITELN;
     
     Anzahl_Schritte:=0;
     REPEAT
       Anzahl_Schritte:=Anzahl_Schritte+1;
       WRITE('  Soll Thema (u)nver�ndert bleiben oder (v)ariiert werden ');
       READ(kbd,x);
       WRITELN(x);
       IF UPCASE(X)='V' THEN
         Satzform[Anzahl_Schritte]:=Variation;
       IF UPCASE(x)='U' THEN
         Satzform[Anzahl_Schritte]:=Thema;
     UNTIL ((UPCASE(x)<>'V') AND (UPCASE(x)<>'U')) OR
           (Anzahl_Schritte>Max_Anzahl_Schritte);
     Anzahl_Schritte:=Anzahl_Schritte-1;
     WRITELN;
     
     WRITE('  Bitte Anzahl S�tze angeben : ');
     READLN(Anzahl_Saetze);
     
     WRITE('  Bitte Tondauer im ersten Satz angeben : ');
     READLN(Tondauer);
     
     WRITE('  Bitte Prestofaktor angeben : ');
       READLN(Prestofaktor);
   END;

 PROCEDURE Gib_Saetze_aus;
   VAR i,u : INTEGER;
       x   : CHAR;
   
   PROCEDURE bilde_Satz (Schachtelung,Variationen : INTEGER);
     
     FUNCTION variiert (Note : Char) : Char ;
       VAR i : INTEGER;
           x : CHAR;
       BEGIN
         FOR i:=1 TO Anzahl_Toene DO
           IF Abbildungsregel[i].Alt=Note THEN x:=Abbildungsregel[i].Neu;
         variiert:=x;
       END;
     
     VAR i,u    : INTEGER;
         x      : CHAR;
     BEGIN
       IF Schachtelung>0 THEN
         FOR i:=1 TO Anzahl_Schritte DO
           IF Satzform[i]=Thema THEN
             bilde_Satz(Schachtelung-1,Variationen)
                                  ELSE
             bilde_Satz(Schachtelung-1,Variationen+1)
       ELSE
       BEGIN
         FOR i:=1 TO Motivlaenge DO
         BEGIN
             x:=Motiv[i];
             IF Variationen>0 THEN
               FOR u:=1 TO Variationen DO
                 x:=variiert(x);
             WRITE(x);
         END;
         WRITE(' ');
       END;
     END;
   
   BEGIN
     FOR i:=1 TO Anzahl_Saetze DO
     BEGIN
       CLRSCR;WRITE('Computer-Composition :  -');
       FOR u:=1 TO Motivlaenge DO WRITE(Motiv[u]);
       WRITE('- ; Satz ',i,' ; Tondauer : ');
       IF i>1 THEN Tondauer:=Tondauer/Prestofaktor;
       WRITELN(Tondauer:3:2);
       WRITELN;WRITE(' ');
       bilde_Satz(i,0);
       READ(kbd,x);
     END;
   END;
   
 BEGIN
   Eingabe;
   Gib_Saetze_aus;
 END.

{
 Problemstellung :

 Sue Dama ist bekannt f�r ihre anspruchsvollen Kompositionen. Sie benutzt
 immer nur die f�nf Tonstufen C,D,F,G und A.
 Zun�chst gibt sie ein Thema aus n gleichlangen T�nen vor. Jede Tonstufe kann
 dabei mehrfach, einfach oder gar nicht vorkommen. Ein Thema f�r n=4 ist
 zum Beispiel "AGCA"
 Weiter denkt sie sich eine Abbildungsregel zwischen den Tonstufen aus, deren
 Anwendung auf das Thema automatisch eine Variation ergibt. Die Abbildungs-
 regel " C->F,D->D,F->D,G->C,A->G " ergibt f�r das Beispielthema die Variation
 "GCFG".
 Jetzt w�hlt sie noch eine Satzform, die aus einer beliebigen Aneinanderreihung
 von Thema und Variation besteht. F�r die Satzform "Thema-Variation-Variation-
 Thema" sieht der erste Satz ihrer Komposition im Beispiel nun so aus :
 "AGCA GCFG GCFG AGCA".
 Den zweiten Satz komponiert Sue Dama, indem sie den ganzen ersten Satz als
 Thema nimmt, und die Abbildungsregel und die Abbildungsregel und die Satzform
 darauf wiederholt. F�r das Beispiel lautet der zweite Satz damit :
 "AGCAAGCFGGCFGAGCAGCFGCFDCCFDCGCFGGCFGCFDCCFDCGCFGAGCAAGCFGGCFGAGCA".
 Weil der zweite Satz viel mehr T�ne hat alsder erste, spielt ihn Sue Dama um
 einen Prestofaktor schneller. Ist der Prestofaktor etwa gleich 2.0, dann
 dauern alle T�ne nur halb so lang wie im vorhergehenden Satz.
 Der dritte, noch schnellere Satz ergibt sich aus dem zweiten, ebenso wie der
 zweite aus dem ersten Satz. Der vierte Satz ergibt sich analog aus dem dritten
 usw.
 Schreibe ein Programm, das im Stil von Sue Dama komponiert, wenn man ihm ein
 Thema, eine Abbildungsregel, eine Satzform, die Anzahl der gew�nschten S�tze,
 die Tondauer im ersten Satz und einen Prestofaktor eingibt.
 
 Beispiel :
 
 Thema,Abbildungsregel und Satzform wie oben besprochen.
 Anzahl S�tze : 3; Prestofaktor 2; Tonl�nge am Anfang 1.
 Ergebnisse wie oben angef�hrt.
  
 Besonderheiten :
 
 Rekursion, Variablen, IF-THEN-Strukturen ohne Semikolons/ENDs.
 
}
  
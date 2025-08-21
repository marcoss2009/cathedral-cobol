       IDENTIFICATION DIVISION.
       PROGRAM-ID. FORMAT-FECHA.
       AUTHOR. MARCOS MUÑOZ.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-FECHA            PIC X(14).
       01  FECHA-MOVIMIENTO-FORMAT REDEFINES WS-FECHA.
               05 ANIO                      PIC X(4).
               05 MES                       PIC X(2).
               05 DIA                       PIC X(2).
               05 HORA                      PIC X(2).
               05 MINUTO                    PIC X(2).
               05 SEGUNDO                   PIC X(2).

       01  FECHA-SALIDA.
               05 DIA-SALIDA                PIC X(2).
               05 FILLER                    PIC X VALUE "/".
               05 MES-SALIDA                PIC X(2).
               05 FILLER                    PIC X VALUE "/".
               05 ANIO-SALIDA               PIC X(4).
               05 FILLER                    PIC X VALUE " ".
               05 HORA-SALIDA               PIC X(2).
               05 FILLER                    PIC X VALUE ":".
               05 MIN-SALIDA                PIC X(2).
               05 FILLER                    PIC X VALUE ":".
               05 SEG-SALIDA                PIC X(2).

       LINKAGE SECTION.
       01  LK-FECHA    PIC X(19).
       01  LK-FECHA-MOVIMIENTO PIC X(14).

       PROCEDURE DIVISION USING LK-FECHA LK-FECHA-MOVIMIENTO.
       000-MAIN-LOGIC SECTION.
           PERFORM 100-FORMAT-FECHA.
           PERFORM 900-FINALIZAR-PROGRAMA.

           100-FORMAT-FECHA SECTION.
               MOVE LK-FECHA-MOVIMIENTO TO WS-FECHA.
               MOVE WS-FECHA TO FECHA-MOVIMIENTO-FORMAT.

               MOVE DIA    TO DIA-SALIDA.
               MOVE MES    TO MES-SALIDA.
               MOVE ANIO   TO ANIO-SALIDA.
               MOVE HORA   TO HORA-SALIDA.
               MOVE MINUTO TO MIN-SALIDA.
               MOVE SEGUNDO TO SEG-SALIDA.

               MOVE FECHA-SALIDA TO LK-FECHA.
            
           900-FINALIZAR-PROGRAMA SECTION.
               EXIT PROGRAM.

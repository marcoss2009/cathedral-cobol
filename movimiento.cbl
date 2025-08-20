       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOVIMIENTO-CUENTA.
       AUTHOR. MARCOS MUÑOZ.

      * Este programa va a escribir los movimientos de una cuenta
      * y actualizar saldos.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARCHIVO-CUENTAS ASSIGN TO 'cuentas.dat'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

           SELECT ARCHIVO-TEMP ASSIGN TO 'temp.dat'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-CUENTAS.
           01  RCC.
           COPY "cuenta.cpy".

       FD  ARCHIVO-TEMP.
           01 RCC-TEMP.
           COPY "cuenta.cpy".


       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS        PIC XX VALUE '00'.

       01  WS-EOF-FLAG           PIC X(01) VALUE 'N'.
           88 FIN-ARCHIVO        VALUE 'Y'.

       01  CUENTA-ENCONTRADA     PIC X(01) VALUE 'N'.

       LINKAGE SECTION.
       01  LK-CUENTA             PIC 9(08).
       01  LK-MONTO              PIC S9(12)V99.
       01  LK-OPERACION          PIC X(01) VALUE SPACE.
           88 DEPOSITO            VALUE 'D'.
           88 RETIRO              VALUE 'R'.

       PROCEDURE DIVISION USING LK-CUENTA LK-MONTO LK-OPERACION.
       000-MAIN-LOGIC.
           PERFORM 100-ACTUALIZAR-CUENTA.
           PERFORM 900-FINALIZAR-PROGRAMA.

           100-ACTUALIZAR-CUENTA SECTION.
      *    Abrimos el archivo y buscamos la cuenta
               OPEN INPUT ARCHIVO-CUENTAS.
               PERFORM UNTIL FIN-ARCHIVO
                   READ ARCHIVO-CUENTAS INTO RCC
                       AT END
                           SET FIN-ARCHIVO TO TRUE
                       NOT AT END
                           IF LK-CUENTA = CC-NUMERO-CUENTA OF RCC
                               MOVE 'S' TO CUENTA-ENCONTRADA
                               EXIT PERFORM
                           END-IF
                   END-READ
               END-PERFORM.
               CLOSE ARCHIVO-CUENTAS.

      *    En teoría la cuenta ya está validada...
      *    Y el saldo tambien...
      *    Si bien LK-OPERACION solo tiene dos valores, no descarto
      *    a futuro que tal vez se agreguen más. Así que vamos a usar
      *    EVALUATE en vez de un IF.

               EVALUATE LK-OPERACION
                   WHEN 'D'
                       PERFORM 110-REALIZAR-DEPOSITO
                    WHEN 'R'
                        PERFORM 120-REALIZAR-RETIRO
                END-EVALUATE.

           110-REALIZAR-DEPOSITO SECTION.
               OPEN INPUT ARCHIVO-CUENTAS
                OUTPUT ARCHIVO-TEMP.

               PERFORM UNTIL FIN-ARCHIVO
                   READ ARCHIVO-CUENTAS INTO RCC
                       AT END
                           SET FIN-ARCHIVO TO TRUE
                       NOT AT END
                           IF LK-CUENTA = CC-NUMERO-CUENTA OF RCC
                               ADD LK-MONTO TO CC-SALDO OF RCC
                           END-IF
                           WRITE RCC-TEMP FROM RCC
                   END-READ
               END-PERFORM.
      
               CLOSE ARCHIVO-CUENTAS
                     ARCHIVO-TEMP.
      *    Actualizamos cuentas.dat con el contenido de temp.dat   
               CALL "SYSTEM" USING "mv temp.dat cuentas.dat".

           120-REALIZAR-RETIRO SECTION.
               OPEN INPUT ARCHIVO-CUENTAS
                OUTPUT ARCHIVO-TEMP.

               PERFORM UNTIL FIN-ARCHIVO
                   READ ARCHIVO-CUENTAS INTO RCC
                       AT END
                           SET FIN-ARCHIVO TO TRUE
                       NOT AT END
                           IF LK-CUENTA = CC-NUMERO-CUENTA OF RCC
                               SUBTRACT LK-MONTO FROM CC-SALDO OF RCC
                           END-IF
                           WRITE RCC-TEMP FROM RCC
                   END-READ
               END-PERFORM.
      
               CLOSE ARCHIVO-CUENTAS
                     ARCHIVO-TEMP.
      *    Actualizamos cuentas.dat con el contenido de temp.dat   
               CALL "SYSTEM" USING "mv temp.dat cuentas.dat".


           900-FINALIZAR-PROGRAMA SECTION.
               EXIT PROGRAM.

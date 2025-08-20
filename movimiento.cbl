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

      *    Archivo de movimientos de la cuenta individual
      *    Inicialmente lo abrimos en una instancia dinámica
      *    Y luego le asignamos el nombre cuentas/<LK-CUENTA>.dat
           SELECT ARCHIVO-MOVIMIENTOS
           ASSIGN TO DYNAMIC NOMBRE-ARCHIVO-MOV
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS-MOV.

       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-CUENTAS.
           01  RCC.
           COPY "cuenta.cpy".

       FD  ARCHIVO-MOVIMIENTOS.
           01 REGISTRO-MOVIMIENTO.
               COPY "movimientos.cpy".

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS        PIC XX VALUE '00'.

       01  WS-EOF-FLAG           PIC X(01) VALUE 'N'.
           88 FIN-ARCHIVO        VALUE 'Y'.

       01  WS-FILE-STATUS-MOV   PIC XX VALUE '00'.
       01  NOMBRE-ARCHIVO-MOV   PIC X(100).

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
               OPEN I-O ARCHIVO-CUENTAS.
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
               
      *    Asignamos el archivo de la cuenta para escribir el movimiento
           STRING 
               "cuentas/" DELIMITED BY SIZE
               LK-CUENTA DELIMITED BY SIZE
               ".dat" DELIMITED BY SIZE
               INTO NOMBRE-ARCHIVO-MOV
           END-STRING.

      *    Abrimos el archivo de movimientos de la cuenta LK-CUENTA
           OPEN EXTEND ARCHIVO-MOVIMIENTOS.

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
               ADD LK-MONTO TO CC-SALDO OF RCC

               MOVE 'H' TO TIPO-MOVIMIENTO OF REGISTRO-MOVIMIENTO.
               MOVE LK-MONTO TO MONTO OF REGISTRO-MOVIMIENTO.

               MOVE FUNCTION CURRENT-DATE
               TO FECHA-MOVIMIENTO OF REGISTRO-MOVIMIENTO.

           120-REALIZAR-RETIRO SECTION.
               SUBTRACT LK-MONTO FROM CC-SALDO OF RCC

               MOVE 'D' TO TIPO-MOVIMIENTO OF REGISTRO-MOVIMIENTO.
               MOVE LK-MONTO TO MONTO OF REGISTRO-MOVIMIENTO.

               MOVE FUNCTION CURRENT-DATE
               TO FECHA-MOVIMIENTO OF REGISTRO-MOVIMIENTO.

           900-FINALIZAR-PROGRAMA SECTION.
      *        Escribimos los cambios y cerramos los archivos
               REWRITE RCC.
               CLOSE ARCHIVO-CUENTAS.

               WRITE REGISTRO-MOVIMIENTO.
               CLOSE ARCHIVO-MOVIMIENTOS.

               EXIT PROGRAM.

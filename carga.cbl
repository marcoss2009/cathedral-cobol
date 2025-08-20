       IDENTIFICATION DIVISION.
       PROGRAM-ID. CARGAR-CUENTA-CORRIENTE.
       AUTHOR. MARCOS MUÑOZ.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARCHIVO-CUENTAS ASSIGN TO 'cuentas.dat'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

      *    Vamos a crear un archivo de movimientos para almacenar
      *    los movimientos de cada cuenta individualmente.
           SELECT ARCHIVO-MOVIMIENTOS 
           ASSIGN TO DYNAMIC NOMBRE-ARCHIVO-MOV
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS-MOV.

       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-CUENTAS.
           01 REGISTRO-CUENTA-CORRIENTE.
               COPY "cuenta.cpy".

       FD  ARCHIVO-MOVIMIENTOS.
           01 REGISTRO-MOVIMIENTO.
               COPY "movimientos.cpy".


       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS        PIC XX VALUE '00'.

       01  WS-EOF-FLAG            PIC X(01) VALUE 'N'.
           88 FIN-ARCHIVO         VALUE 'Y'.

       01  WS-FILE-STATUS-MOV      PIC XX VALUE '00'.
       01  NOMBRE-ARCHIVO-MOV       PIC X(100).
       01  RCC-MOV                  PIC X(1) VALUE SPACE.

       PROCEDURE DIVISION.
       000-MAIN-LOGIC SECTION.
           PERFORM 100-APERTURA-DE-CUENTA.
           PERFORM 900-FINALIZAR-PROGRAMA.

           100-APERTURA-DE-CUENTA SECTION.
               DISPLAY '--- APERTURA DE CUENTAS CORRIENTES ---'.
               OPEN EXTEND ARCHIVO-CUENTAS.
               IF WS-FILE-STATUS NOT = '00'
                   DISPLAY 'Error al abrir archivo de cuentas'
               END-IF.
      
               DISPLAY 'Titular: ' WITH NO ADVANCING.
               ACCEPT CC-NOMBRE-CLIENTE.
      
               DISPLAY 'Numero de Cuenta: ' WITH NO ADVANCING.
               ACCEPT CC-NUMERO-CUENTA.
      
               MOVE 0.00 TO CC-SALDO.
               MOVE 'A' TO CC-ESTADO-CUENTA.
               WRITE REGISTRO-CUENTA-CORRIENTE.

      *        Generamos el nombre del archivo de esta cuenta
               STRING 
                       "cuentas/" DELIMITED BY SIZE 
                       CC-NUMERO-CUENTA DELIMITED BY SIZE
                       ".dat" DELIMITED BY SIZE
                       INTO NOMBRE-ARCHIVO-MOV
               END-STRING.

      *        Generamos el archivo vacio
               OPEN OUTPUT ARCHIVO-MOVIMIENTOS
               IF WS-FILE-STATUS-MOV NOT = '00'
                   DISPLAY "ERROR AL CREAR ARCHIVO DE MOVIMIENTOS"
               ELSE
                   DISPLAY "ARCHIVO DE MOVIMIENTOS CREADO CORRECTAMENTE"
               END-IF
               CLOSE ARCHIVO-MOVIMIENTOS
      
               CLOSE ARCHIVO-CUENTAS.
               DISPLAY 'Cuenta creada correctamente'.

           900-FINALIZAR-PROGRAMA SECTION.
               STOP RUN.

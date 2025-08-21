       IDENTIFICATION DIVISION.
       PROGRAM-ID. ALTA-CUENTA-CORRIENTE.
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

      *    Sé que no es lo más eficiente pero por el momento
      *    el número de cuenta será incremental, y para esto
      *    voy a crear un archivo contador para saber cuál es el
      *    último número de cuenta.
           SELECT ARCHIVO-CONTADOR ASSIGN TO 'contador.dat'
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS-CONTADOR.

       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-CUENTAS.
           01 REGISTRO-CUENTA-CORRIENTE.
               COPY "cuenta.cpy".

       FD  ARCHIVO-MOVIMIENTOS.
           01 REGISTRO-MOVIMIENTO.
               COPY "movimientos.cpy".

       FD  ARCHIVO-CONTADOR.
           01 REGISTRO-CONTADOR.
               05 CONTADOR-CUENTA PIC 9(08).

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS        PIC XX VALUE '00'.

       01  WS-EOF-FLAG            PIC X(01) VALUE 'N'.
           88 FIN-ARCHIVO         VALUE 'Y'.

       01  WS-FILE-STATUS-MOV      PIC XX VALUE '00'.
       01  NOMBRE-ARCHIVO-MOV       PIC X(100).

       01  WS-FILE-STATUS-CONTADOR PIC XX VALUE '00'.

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

               OPEN I-O ARCHIVO-CONTADOR.
               IF WS-FILE-STATUS-CONTADOR NOT = '00'
                   DISPLAY 'Error al abrir archivo de contador'
               END-IF.

               DISPLAY 'Titular: ' WITH NO ADVANCING.
               ACCEPT CC-NOMBRE-CLIENTE.

      *        Obtengo el último número de cuenta
               READ ARCHIVO-CONTADOR INTO REGISTRO-CONTADOR
               END-READ.

      *        Le sumamos uno
               ADD 1 TO CONTADOR-CUENTA OF REGISTRO-CONTADOR.

      *        Ojo, usamos REWRITE, no WRITE, ya que se mantiene
      *        el mismo registro
               REWRITE REGISTRO-CONTADOR.
               CLOSE ARCHIVO-CONTADOR.

               MOVE CONTADOR-CUENTA TO CC-NUMERO-CUENTA.
               MOVE 0.00 TO CC-SALDO.
               MOVE 'A' TO CC-ESTADO-CUENTA.
               WRITE REGISTRO-CUENTA-CORRIENTE.
               CLOSE ARCHIVO-CUENTAS.

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
                   DISPLAY 'Cuenta creada correctamente'
                   DISPLAY 'Número de Cuenta: ' CC-NUMERO-CUENTA
               END-IF.
               CLOSE ARCHIVO-MOVIMIENTOS.
      
           900-FINALIZAR-PROGRAMA SECTION.
               EXIT PROGRAM.

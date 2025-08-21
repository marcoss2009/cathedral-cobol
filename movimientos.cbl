       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONSULTAR-MOVIMIENTOS.
       AUTHOR. MARCOS MUÑOZ.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARCHIVO-MOVIMIENTOS
           ASSIGN TO DYNAMIC NOMBRE-ARCHIVO-MOV
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS-MOV.
      
       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-MOVIMIENTOS.
           01 REGISTRO-MOVIMIENTOS.
               COPY "movimientos.cpy".
        
       WORKING-STORAGE SECTION.
       01  CUENTA-CORRIENTE.
           COPY "cuenta.cpy".

       01  WS-MONTO-DISPLAY    PIC $ZZZ,ZZZ,ZZZ,ZZ9.99.
       
       01  WS-FILE-STATUS-MOV   PIC XX VALUE '00'.
       01  NOMBRE-ARCHIVO-MOV   PIC X(100).

       01  WS-EOF-FLAG           PIC X(01) VALUE 'N'.
           88 FIN-ARCHIVO        VALUE 'Y'.

       01  WS-FECHA            PIC X(19).
      
       PROCEDURE DIVISION.
       000-MAIN-LOGIC SECTION.
           MOVE 'N' TO WS-EOF-FLAG.
           
           PERFORM 100-CONSULTAR-CUENTA.
           PERFORM 110-IMPRIMIR-MOVIMIENTOS.
           PERFORM 900-FINALIZAR-PROGRAMA.

           100-CONSULTAR-CUENTA SECTION.
               DISPLAY '==== Consulta de Movimientos de Cuenta ===='.
               CALL 'BUSCAR-CUENTA' USING CUENTA-CORRIENTE.
      
               DISPLAY '---- Datos de Cuenta ----'
               DISPLAY 'Cliente: ' CC-NOMBRE-CLIENTE OF CUENTA-CORRIENTE.
               DISPLAY 'Número de Cuenta: ' 
               CC-NUMERO-CUENTA OF CUENTA-CORRIENTE.
               MOVE CC-SALDO OF CUENTA-CORRIENTE TO WS-MONTO-DISPLAY.
               DISPLAY 'Saldo: ' WS-MONTO-DISPLAY.

           110-IMPRIMIR-MOVIMIENTOS SECTION.
               DISPLAY '---- Movimientos de Cuenta ----'.

      *        Asignamos el archivo de la cuenta para escribir el movimiento
               STRING 
                   "cuentas/" DELIMITED BY SIZE
                   CC-NUMERO-CUENTA OF CUENTA-CORRIENTE
                   DELIMITED BY SIZE
                   ".dat" DELIMITED BY SIZE
                   INTO NOMBRE-ARCHIVO-MOV
               END-STRING.

               OPEN INPUT ARCHIVO-MOVIMIENTOS.
               
               PERFORM UNTIL FIN-ARCHIVO
                   READ ARCHIVO-MOVIMIENTOS INTO REGISTRO-MOVIMIENTOS
                       AT END
                           SET FIN-ARCHIVO TO TRUE
                        NOT AT END
                            MOVE MONTO OF REGISTRO-MOVIMIENTOS 
                            TO WS-MONTO-DISPLAY

                            DISPLAY 'Monto: ' WS-MONTO-DISPLAY

      *                     Voy a crear un módulo para formatear fechas
      *                     ya que es un proceso más complejo de lo
      *                     que parece...
                            CALL 'FORMAT-FECHA' USING 
                            WS-FECHA 
                            FECHA-MOVIMIENTO OF REGISTRO-MOVIMIENTOS

                            DISPLAY 'Fecha: ' WS-FECHA
                            
                            EVALUATE 
                            TIPO-MOVIMIENTO OF REGISTRO-MOVIMIENTOS
                                WHEN 'H'
                                    DISPLAY 'Movimiento: Depósito'
                                WHEN 'D'
                                    DISPLAY 'Movimiento: Extracción'
                                WHEN OTHER
                                    DISPLAY 
                                    'Tipo de movimiento desconocido'
                            END-EVALUATE

                            DISPLAY '-------------------------------'
                    END-READ
                END-PERFORM.

               CLOSE ARCHIVO-MOVIMIENTOS.

           900-FINALIZAR-PROGRAMA SECTION.
               EXIT PROGRAM.

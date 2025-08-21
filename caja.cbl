       IDENTIFICATION DIVISION.
       PROGRAM-ID. CAJA.
       AUTHOR. MARCOS MUÑOZ.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  CUENTA-CORRIENTE.
           COPY "cuenta.cpy".

       01  WS-SALDO-DISPLAY       PIC $ZZZ,ZZZ,ZZZ,ZZ9.99.

       01  OPCION-CAJA            PIC 9.
       01  WS-MONTO               PIC S9(12)V99.

      * Bandera para validar la opción de acción de caja
       01  OPCION-VALIDA          PIC X VALUE 'N'.
           88  VALIDA        VALUE 'S'.
           88  INVALIDA      VALUE 'N'.

      * Bandera para valida si el monto ingresado es correcto
       01  VALIDACION-MONTO           PIC X VALUE 'N'.
           88 MONTO-VALIDO   VALUE 'S'.
           88 MONTO-INVALIDO VALUE 'N'.

       PROCEDURE DIVISION.
       000-MAIN-LOGIN SECTION.
           DISPLAY '---- OPERACIONES DE CAJA ----'.
           PERFORM 100-BUSQUEDA-DE-CUENTA.
           PERFORM 200-ACCION-DE-CAJA.
           PERFORM 900-FINALIZAR-PROGRAMA.

           100-BUSQUEDA-DE-CUENTA SECTION.
               CALL 'BUSCAR-CUENTA' USING CUENTA-CORRIENTE.
               MOVE CC-SALDO OF CUENTA-CORRIENTE TO WS-SALDO-DISPLAY.
               
               DISPLAY '--> Cliente: ' 
               CC-NOMBRE-CLIENTE OF CUENTA-CORRIENTE.

               DISPLAY '--> Saldo: ' WS-SALDO-DISPLAY.

           200-ACCION-DE-CAJA SECTION.
               PERFORM UNTIL VALIDA
                   DISPLAY '----> Seleccione la acción a realizar:'
                   DISPLAY '1. Depositar'
                   DISPLAY '2. Retirar'
                   DISPLAY '3. Consultar Saldo'
                   DISPLAY 'Elija una opción: ' WITH NO ADVANCING
                   ACCEPT OPCION-CAJA
      
                   EVALUATE OPCION-CAJA
                       WHEN 1
                           SET VALIDA TO TRUE
                       WHEN 2
                           SET VALIDA TO TRUE
                       WHEN 3
                           SET VALIDA TO TRUE
                       WHEN OTHER
                           DISPLAY '--> OPCIÓN INVÁLIDA'
                   END-EVALUATE
               END-PERFORM.

               EVALUATE OPCION-CAJA
                   WHEN 1
                       PERFORM 210-DEPOSITO
                   WHEN 2
                       PERFORM 220-RETIRO
                   WHEN 3
                       PERFORM 230-CONSULTA-SALDO
               END-EVALUATE.

           210-DEPOSITO SECTION.
               DISPLAY "--- DEPÓSITO DE SALDOS ---".
               DISPLAY "Ingrese el monoto de depositar: $" 
               WITH NO ADVANCING.
               ACCEPT WS-MONTO.

               PERFORM UNTIL MONTO-VALIDO
                   IF WS-MONTO >= 1
                       SET MONTO-VALIDO TO TRUE
                   ELSE
                       DISPLAY "--> MONTO INVÁLIDO"
                       DISPLAY "INGRESE UN MONTO MAYOR A CERO."
                       ACCEPT WS-MONTO
                   END-IF
               END-PERFORM.

               ADD WS-MONTO TO CC-SALDO OF CUENTA-CORRIENTE.
               MOVE CC-SALDO OF CUENTA-CORRIENTE TO WS-SALDO-DISPLAY.

               CALL 'MOVIMIENTO-CUENTA' 
               USING CC-NUMERO-CUENTA OF CUENTA-CORRIENTE WS-MONTO 'D'.
               
               DISPLAY "---> DEPÓSITO CONFIRMADO S.E.U.O".
           220-RETIRO SECTION.
               DISPLAY "--- RETIRO DE SALDOS ---".
               DISPLAY "Ingrese el monoto a retirar: $" 
               WITH NO ADVANCING.
               ACCEPT WS-MONTO.

               PERFORM UNTIL MONTO-VALIDO
                   IF WS-MONTO >= 1 
                       IF WS-MONTO <= CC-SALDO OF CUENTA-CORRIENTE
                           SET MONTO-VALIDO TO TRUE
                        ELSE
                            DISPLAY "--> MONTO INVÁLIDO"
                            DISPLAY "INGRESE UN MONTO MENOR O IGUAL "
                            DISPLAY "AL SALDO DISPONIBLE."
                            DISPLAY "Ingrese el monoto a retirar: $" 
                            WITH NO ADVANCING
                            ACCEPT WS-MONTO
                        END-IF
                   ELSE
                       DISPLAY "--> MONTO INVÁLIDO"
                       DISPLAY "INGRESE UN MONTO MAYOR A CERO."
                       DISPLAY "Ingrese el monoto a retirar: $" 
                       WITH NO ADVANCING
                       ACCEPT WS-MONTO
                   END-IF
               END-PERFORM.

               SUBTRACT WS-MONTO FROM CC-SALDO OF CUENTA-CORRIENTE.
               MOVE CC-SALDO OF CUENTA-CORRIENTE TO WS-SALDO-DISPLAY.

               CALL 'MOVIMIENTO-CUENTA' 
               USING CC-NUMERO-CUENTA OF CUENTA-CORRIENTE WS-MONTO 'R'.
               
               DISPLAY "---> RETIRO CONFIRMADO S.E.U.O".
           230-CONSULTA-SALDO SECTION.
               DISPLAY "--- CONSULTA DE SALDO ---".
               DISPLAY "Saldo actual: " WS-SALDO-DISPLAY.

           900-FINALIZAR-PROGRAMA SECTION.
               EXIT PROGRAM.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. CATHEDRAL-COBOL.
       AUTHOR. MARCOS MUÑOZ.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  OPCION PIC 9.

       PROCEDURE DIVISION.
       000-MAIN-LOGIC SECTION.
           PERFORM 100-CATHEDRAL.
           PERFORM 900-FINALIZAR-PROGRAMA.

           100-CATHEDRAL SECTION.
               PERFORM UNTIL OPCION = 9
                   DISPLAY "======== Cathedral Software ========"
                   DISPLAY "1 - Alta de Cuentas"
                   DISPLAY "2 - Consulta de Cuentas"
                   DISPLAY "3 - Movimientos de Cuentas"
                   DISPLAY "8 - Caja"
                   DISPLAY "9 - Salir"
                   DISPLAY "Seleccione una opción: "
                   WITH NO ADVANCING
                   ACCEPT OPCION

                   EVALUATE OPCION
                       WHEN 1 CALL 'ALTA-CUENTA-CORRIENTE'
                       WHEN 2 CALL 'CONSULTAR-CUENTA'
                       WHEN 3 CALL 'CONSULTAR-MOVIMIENTOS'
                       WHEN 8 CALL 'CAJA'
                       WHEN 9 CONTINUE
                       WHEN OTHER
                           DISPLAY "--> Opción inválida"
                   END-EVALUATE
               END-PERFORM.

           900-FINALIZAR-PROGRAMA SECTION.
               DISPLAY "======== Cathedral Software ========".
               DISPLAY "                                   π".
               STOP RUN.

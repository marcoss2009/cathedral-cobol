       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONSULTAR-CUENTA.
       AUTHOR. MARCOS MUÑOZ.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  CCB.
           COPY "cuenta.cpy".

       01  WS-SALDO-DISPLAY     PIC $ZZZ,ZZZ,ZZZ,ZZ9.99.

       PROCEDURE DIVISION.
       000-MAIN-LOGIC SECTION.
           PERFORM 100-CONSULTAR-CUENTA.
           PERFORM 900-FINALIZAR-PROGRAMA.

           100-CONSULTAR-CUENTA SECTION.
               DISPLAY '==== Consulta de Cuenta ===='.
               CALL 'BUSCAR-CUENTA' USING CCB.
      
               MOVE CC-SALDO OF CCB TO WS-SALDO-DISPLAY.

               DISPLAY '------------------------------------'.
               DISPLAY '          DETALLE DE CUENTA         '.
               DISPLAY '------------------------------------'.
               DISPLAY 'Número de Cuenta: ' CC-NUMERO-CUENTA OF CCB.
               DISPLAY 'Nombre Cliente:   ' CC-NOMBRE-CLIENTE OF CCB.
               DISPLAY 'Saldo:            ' WS-SALDO-DISPLAY.
               DISPLAY 'Estado:           ' CC-ESTADO-CUENTA OF CCB.

           900-FINALIZAR-PROGRAMA SECTION.
               EXIT PROGRAM.

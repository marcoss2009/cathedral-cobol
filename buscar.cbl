       IDENTIFICATION DIVISION.
       PROGRAM-ID. BUSCAR-CUENTA.
       AUTHOR. MARCOS MUÑOZ.

      * ¿Por qué este programa?
      * Básicamente me dí cuenta que en todos los programas necesito
      * buscar cuentas para luego interactuar con las mismas.
      * Así que prefiero buscarlas en un solo programa y devolver el parámetro.
      * No sé si es lo ideal, pero ya no conozco algún programador COBOL
      * para preguntarle.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARCHIVO-CUENTAS ASSIGN TO 'cuentas.dat'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-CUENTAS.
           01  RCC.
           COPY "cuenta.cpy".

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS        PIC XX VALUE '00'.

       01  WS-EOF-FLAG           PIC X(01) VALUE 'N'.
           88 FIN-ARCHIVO        VALUE 'Y'.

       01  TIPO-BUSQUEDA         PIC 9.
       01  NOMBRE-CLIENTE        PIC X(30) VALUE SPACES.
       01  NUMERO-CUENTA         PIC 9(08).
       01  CUENTA-ENCONTRADA     PIC X(01) VALUE 'N'.

       LINKAGE SECTION.
       01  LK-CUENTA.
           COPY "cuenta.cpy".

       PROCEDURE DIVISION USING LK-CUENTA.
       000-MAIN-LOGIC SECTION.
           PERFORM 100-CONSULTA-DE-CUENTA.
           PERFORM 900-FINALIZAR-PROGRAMA.

           100-CONSULTA-DE-CUENTA SECTION.
               DISPLAY '---- BÚSQUEDA DE CUENTA ----'.

               PERFORM UNTIL CUENTA-ENCONTRADA = 'S'
      *        SOY UN BOLUDO, ME OLVIDE DE REINICIAR LAS BANDERAS
      *        REINICIAMOS LAS BANDERAS DE CUENTA-ENCONTRADA Y WS-EOF-FLAG
      *        Y LIMPIAMOS LK-CUENTA
                   MOVE 'N' TO CUENTA-ENCONTRADA
                   MOVE 'N' TO WS-EOF-FLAG
                   INITIALIZE LK-CUENTA

                   DISPLAY 'Seleccione el tipo de búsqueda:'
                   DISPLAY SPACE

                   DISPLAY '1. Por número de cuenta'
                   DISPLAY '2. Por nombre de cliente'
                   DISPLAY SPACE

                   DISPLAY 'Elija tipo de búsqueda: ' WITH NO ADVANCING
                   ACCEPT TIPO-BUSQUEDA

                    EVALUATE TIPO-BUSQUEDA
                        WHEN 1
                            PERFORM 120-BUSQUEDA-POR-CUENTA
                        WHEN 2
                            PERFORM 130-BUSQUEDA-POR-NOMBRE
                        WHEN OTHER
                            DISPLAY '----> OPCION INCORRECTA'
                        END-EVALUATE

                    IF CUENTA-ENCONTRADA NOT = 'S'
                        DISPLAY '----> CUENTA NO ENCONTRADA'
                    END-IF
                END-PERFORM.

      *        SALIMOS DEL BÚCLE
      *        MOSTRAMOS LA CUENTA
               PERFORM 140-MOSTRAR-CUENTA.

           120-BUSQUEDA-POR-CUENTA SECTION.
               DISPLAY '----> BÚSQUEDA POR CUENTA'.
               DISPLAY 'Ingrese número de cuenta: ' WITH NO ADVANCING.
               ACCEPT NUMERO-CUENTA.

      *    LEEMOS REGISTROS DEL ARCHIVO HASTA ENCONTRAR LA CUENTA
               OPEN INPUT ARCHIVO-CUENTAS.
               PERFORM UNTIL FIN-ARCHIVO
                   READ ARCHIVO-CUENTAS INTO RCC
                       AT END
                           SET FIN-ARCHIVO TO TRUE
                       NOT AT END
                           IF NUMERO-CUENTA = CC-NUMERO-CUENTA OF RCC
                               MOVE 'S' TO CUENTA-ENCONTRADA
                               EXIT PERFORM
                           END-IF
                   END-READ
               END-PERFORM.
               CLOSE ARCHIVO-CUENTAS.

           130-BUSQUEDA-POR-NOMBRE SECTION.
               DISPLAY '----> BÚSQUEDA POR NOMBRE'.
               DISPLAY 'Ingrese nombre del cliente: ' WITH NO ADVANCING.
               ACCEPT NOMBRE-CLIENTE.

      *    LEEMOS REGISTROS DEL ARCHIVO HASTA ENCONTRAR LA CUENTA
               OPEN INPUT ARCHIVO-CUENTAS.
               PERFORM UNTIL FIN-ARCHIVO
                   READ ARCHIVO-CUENTAS INTO RCC
                       AT END
                           SET FIN-ARCHIVO TO TRUE
                       NOT AT END
                           IF NOMBRE-CLIENTE = CC-NOMBRE-CLIENTE OF RCC
                               MOVE 'S' TO CUENTA-ENCONTRADA
                               EXIT PERFORM
                           END-IF
                   END-READ
               END-PERFORM.
               CLOSE ARCHIVO-CUENTAS.

           140-MOSTRAR-CUENTA SECTION.
      *    Envíamos los parámetros de la cuenta
               MOVE RCC TO LK-CUENTA.

           900-FINALIZAR-PROGRAMA SECTION.
               EXIT PROGRAM.

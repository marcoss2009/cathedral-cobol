      * ARCHIVO CON LA DEFINICION DEL REGISTRO DE CUENTAS CORRIENTES
      * PARA LAS BÚSQUEDAS
           05    CC-NUMERO-CUENTA    PIC 9(08).
           05    CC-NOMBRE-CLIENTE   PIC X(30).
           05    CC-SALDO            PIC S9(12)V99.
           05    CC-ESTADO-CUENTA    PIC X(01).
                 88    CUENTA-ACTIVA    VALUE 'A'.
                 88    CUENTA-CERRADA   VALUE 'C'.
                 
      * Archivo para la definición de los registros de movimientos
           05    MONTO          PIC S9(9)V99.
      *    Debe o Haber 
           05    TIPO-MOVIMIENTO PIC X VALUE 'D'.
                 88 DEBE      VALUE 'D'.
                 88 HABER     VALUE 'H'.
      *  Fecha en formato YYYY-MM-DD
           05    FECHA-MOVIMIENTO  PIC X(10).
      *  Futuros parametros: OPERADOR, CANAL
      
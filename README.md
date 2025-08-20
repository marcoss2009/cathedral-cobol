# Cathedral COBOL
Mi curiosidad como programador siempre fue el lenguaje COBOL, comenzando dicha curiosidad en mis tiempos de la escuela secundaria cuando dos profesores (Daniel Salem y Alejandra Gil, que por cierto, son dos profesores que me marcaron muchisimo durante mi preparación profesional) me plantaron esa curiosidad cuando en clases mencionaban cómo habían trabajado con dicho lenguaje durante muchos años y como hablaban apasionadamente sobre él.

Desde entonces siempre tuve la idea de algún día sentarme a aprender dicho lenguaje, el tiempo pasó y nunca tenía tiempo o paciencia para hacerlo, hasta este año que logré encontrar un pequeño hueco en mis tiempos libres para comenzar con pequeñas bases sobre este lenguaje.

Debo confesar que sin ayuda de ChatGPT no hubiera comenzado, ya que muchas dudas técnicas sobre MainFrames, IDE y entornos de programación las canalizé por este medio, y una vez preparado comencé a *codear* las primeras líneas de este maravilloso lenguaje.

Mi idea con este proyecto es hacer un proyecto similar al que hice para la materia de Programación I en la UADE, al que bautizamos junto con mis compañeros como [Cathedral Software](https://github.com/marcoss2009/cathedral-software), un programa de cuentas corrientes programado en Python. No voy a hacer las mismas funcionalidades sino que la idea ahora es simular un entorno de cuentas corrientes a nivel bancario, donde existe un módulo de caja para retiros y depósitos.

Mi objetivo, además de aprender COBOL, es también aprender como funcionan estos entornos que siguen vigentes hasta el día de hoy.

Este repositorio se lo voy a pasar a los únicos dos programadores que conozco que me pueden llegar a dar una review sobre el código y la forma en la que encaré estos programas, por lo que estoy abierto a cualquier crítica constructiva.

## Notas
Voy a utilizar GNU COBOL como compilador.

Comando para compilar un módulo

    cobc -c buscar.cbl

Comando para compilar un programa principal con un módulo

    cobc -x consultar.cbl buscar.o -Icrud
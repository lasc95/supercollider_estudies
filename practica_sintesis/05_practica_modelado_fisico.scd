/*
La síntesis de modelado físico se refiere a métodos en la síntesis de sonido que simulan sistemas físicos. En lugar de recrear el sonido desde una forma de onda o un conjunto de muestras, el modelado físico utiliza algoritmos matemáticos para replicar las características físicas de un instrumento real y cómo reacciona al ser tocado.

Historia:
La idea de simular instrumentos musicales usando modelos matemáticos no es nueva y se remonta a varios siglos. Sin embargo, la aplicación práctica de estas ideas en la síntesis de sonido comenzó en los años 70 y 80 con el advenimiento de las computadoras. Las primeras implementaciones prácticas de la síntesis de modelado físico llegaron en la década de 1990 con instrumentos como el Yamaha VL1.

Cómo funciona:
La síntesis de modelado físico utiliza ecuaciones matemáticas para modelar las propiedades y comportamientos de sistemas físicos, como la vibración de una cuerda o el aire dentro de un tubo. Los dos enfoques más comunes son:

Modelado por Forma de Onda: Se basa en la descripción de la forma de onda producida por un instrumento.
Modelado por Interacción: Se basa en la simulación de cómo se produce el sonido en un instrumento, como el golpeo de una cuerda o el soplido de un tubo.
Ejemplos:

Cuerda pulsada: Modelar una guitarra o un piano implica simular cómo vibra una cuerda cuando se golpea o se pulsa.
Instrumentos de viento: Simular un clarinete o una flauta implica modelar cómo el aire vibra dentro de un tubo cuando se sopla.
Ejemplos con sonidos famosos:

Yamaha VL1: Uno de los primeros sintetizadores comerciales basados en modelado físico, conocido por su capacidad para recrear sonidos de instrumentos de viento y cuerdas con gran realismo.
Karplus-Strong: Un algoritmo simple para simular el sonido de una cuerda pulsada, usado en muchos sintetizadores para recrear sonidos de cuerdas.
Ejemplo práctico en SuperCollider:
La síntesis de modelado físico es un poco más compleja de implementar en un breve ejemplo, pero aquí hay una aproximación simple usando el algoritmo Karplus-Strong:
*/

(
SynthDef(\karplusStrong, {
    arg freq=440, decay=0.995;
    var excitation, loop;

    // Generar una breve ráfaga de ruido como excitación
    excitation = WhiteNoise.ar(Decay.kr(Impulse.kr(0), 0.01));

    // Usar un delay para simular la vibración de la cuerda
    loop = DelayC.ar(excitation, 1/freq, 1/freq, decay);

    Out.ar(0, loop * 0.5);
}).add;
)

// Tocar el Synth:
x = Synt h(\karplusStrong, [freq: 330]);

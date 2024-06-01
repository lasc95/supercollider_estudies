/*
La síntesis AM (modulación de amplitud) es una técnica que ha jugado un papel importante en la historia de la música electrónica y la tecnología del sonido. A continuación, te proporcionaré una descripción detallada de la síntesis AM, similar a una clase, incluyendo su historia, la física detrás de ella, y ejemplos de sonidos característicos.

Historia de la Síntesis AM

La síntesis AM es una de las formas más antiguas de procesamiento de señales. Originalmente se utilizaba en la transmisión de radio AM (Amplitude Modulation), donde la amplitud de una señal de radiofrecuencia (RF) se modulaba para transportar la señal de audio. En la música electrónica, la síntesis AM se comenzó a utilizar en los primeros sintetizadores para crear texturas y timbres ricos que no eran posibles con los instrumentos acústicos tradicionales.

Física de la Síntesis AM

La síntesis AM implica dos componentes principales: una señal portadora y una señal moduladora. La señal portadora es típicamente una onda a una frecuencia constante que se escucha si se toca sola. La señal moduladora es otra onda que, en el contexto de la síntesis AM, controla la amplitud de la señal portadora.

formula:
y(t) = [1 + M * cos(2*pi*fm*t)] * cos(2*pi*fc*t)
donde:

y(t) es la señal de salida
M es el índice de modulación
fm es la frecuencia de la moduladora
fc es la frecuencia de la portadora
t tiempo

El índice de modulación M determina cuánto la señal moduladora afecta la portadora. Cuando  M es 0, no hay modulación y escuchas solo la señal portadora. A medida que aumenta  M, la amplitud de la portadora varía más fuertemente.

En la música, la síntesis AM puede crear efectos de tremolo (cuando la frecuencia de la moduladora está por debajo del rango audible) o sonidos metálicos y campanas (cuando la frecuencia de la moduladora está dentro del rango audible). Algunos ejemplos característicos incluyen:

* Tremolo: Si la señal moduladora está por debajo de 20 Hz, la síntesis AM puede producir un efecto de tremolo, donde la amplitud de la señal portadora fluctúa, creando un efecto de          "temblor" o "vibración" en el sonido.
* Campanas y tonos metálicos: Cuando la señal moduladora está en el rango audible y se elige cuidadosamente en relación con la frecuencia portadora, se pueden crear sonidos que recuerdan a las campanas o a instrumentos metálicos debido a los patrones complejos de interferencia entre las ondas.

*/
(
SynthDef(\amSynth, { |carrierFreq=440, modFreq=5, modIndex=1, amp=0.2|
    var carrier, modulator, signal;

    // Carrier signal
    carrier = SinOsc.ar(carrierFreq);

    // Modulator signal
    modulator = SinOsc.ar(modFreq) * modIndex;

    // AM synthesis
	//+ 1 para que siempre se encuentre en el rango de 0 y 2 en vez de -1 y 1
    signal = (carrier * (modulator + 1 )) * amp;

    // Output
    Out.ar(0, signal.dup);
}).add;)


Synth(\amSynth, [\modFreq, 2, \modIndex,5]);
/*
SINTESIS FM:
Historia:
La síntesis FM fue desarrollada e introducida por John Chowning en los años 60 y 70 en el Instituto de Investigación de Música Computacional de la Universidad de Stanford. Posteriormente, esta técnica fue popularizada por Yamaha con su icónico sintetizador DX7 en 1983. Desde entonces, la síntesis FM ha sido un pilar en la música electrónica y el diseño de sonido.

Concepto Básico:
La síntesis FM implica la modulación de la frecuencia de una onda (llamada portadora) por otra onda (llamada moduladora). El resultado es una generación compleja de armónicos que puede dar lugar a timbres muy variados y ricos.

Parámetros Clave:
Portadora (Carrier): La onda principal cuya frecuencia se modula.
Moduladora (Modulator): La onda que modula la frecuencia de la portadora.
Índice de Modulación: Determina la cantidad de modulación. Un índice más alto resulta en timbres más complejos.
*/


/*
Indice Modulación: es simplemente una medida de cuánta modulación de frecuencia se está aplicando. Específicamente, se refiere a la cantidad en la que la frecuencia de la onda portadora está siendo modulada por la onda moduladora.

Formula: Frecuencia Modulada = FreP + (indiceM  * amplitud de la moduladora)

Impacto del índice de modulación:

Bajo:Con valores bajos de IM, la modulación es sutil. Esto resulta en cambios leves en el timbre del sonido. En general, el sonido resultante será más simple y tendrá menos armónicos.  la modulación se suaviza, y el sonido resultante tiende a ser más suave y menos armónico. Es útil para sonidos más limpios y tonales.

Altos:  Con valores altos de IM, la modulación es intensa. Esto puede introducir una gran cantidad de armónicos adicionales, lo que hace que el sonido sea más rico y complejo. Los sonidos pueden variar desde metálicos hasta atonales, dependiendo de otros parámetros. el sonido se vuelve más rico en armónicos y adquiere un carácter más metálico o agresivo. En síntesis FM, esto es útil para crear sonidos como campanas, bajos metálicos, y efectos de sonido atonales.

*/

//EJEMPLOS:
(
SynthDef(\fmBass, {
    arg freq=100, amp=0.5, modIndex=5, modFreqRatio=0.5, freqModulator=200;
    var carrier, modulator, result;

    modulator = SinOsc.ar(freqModulator * modFreqRatio) * modIndex;
    carrier = SinOsc.ar(freq + modulator);

    result = carrier * amp;
    Out.ar(0, result);
}).add;
)

x = Synth(\fmBass, [\freq, rrand(100, 800), \amp, 0.2, \modIndex, 10, \modFreqRatio, 0.2, \freqModulator, rrand(100, 900)]);





//CAMPANA FM
(
SynthDef(\fmBell, {
    arg freq=660, amp=0.5, modIndex=7, modFreqRatio=2;
    var carrier, modulator, result, env;

    env = EnvGen.kr(Env.perc(0.01, 1), doneAction:2);
    modulator = SinOsc.ar(freq * modFreqRatio) * modIndex;
    carrier = SinOsc.ar(freq + modulator);

    result = carrier * amp * env;
    Out.ar(0, result);
}).add;
)

x = Synth(\fmBell, [\freq, 700, \amp, 0.2, \modIndex, 2, \modFreqRatio, 2])


//PAD FM RADIO
(
SynthDef(\fmPad, {
    arg freq=440, amp=0.5, modIndex=3, freqMod=200;
    var carrier, modulator, result, env;

    env = EnvGen.kr(Env.adsr(2, 1, 0.5, 2), doneAction:2);
    modulator = SinOsc.ar(freqMod) * modIndex;
    carrier = SinOsc.ar(freq + modulator);

    result = carrier * amp * env;
    Out.ar(0, result!2);
}).add;
)

x = Synth(\fmPad, [\freq, 200, \amp, 0.2, \modIndex, 0.2, \freqMod, 700])

//El modFreqRatio solamente es NECESARIO cuando no tenemos una frecuencia especifica para ambos, y lo traza en razón (porque sino serían lo mismo)
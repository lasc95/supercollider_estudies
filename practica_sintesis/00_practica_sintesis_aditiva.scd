/*
Historia:
La síntesis aditiva es uno de los métodos más antiguos y fundamentales para generar sonido. Su concepto se basa en la teoría de Fourier, que sostiene que cualquier sonido o señal periódica puede ser representado como la suma de sinusoides (ondas seno) simples, cada una con su propia amplitud, frecuencia y fase. Esta teoría fue propuesta por el matemático francés Joseph Fourier en el siglo XIX.

En la práctica, esto significa que cualquier sonido complejo puede ser construido sumando juntas muchas ondas senoidales diferentes. En los primeros días de la síntesis electrónica, la síntesis aditiva era difícil de implementar debido a la necesidad de generar y sumar múltiples ondas senoidales. Sin embargo, con el advenimiento de la tecnología digital y el aumento de la potencia de cálculo, la síntesis aditiva se ha vuelto más factible y popular.


Cómo funciona:
1 Generación de Harmónicos: En la síntesis aditiva, se generan múltiples ondas sinusoidales. Cada una de estas ondas representa un harmónico del sonido final.
2 Suma de Ondas: Todas estas ondas sinusoidales se suman juntas para crear un sonido más complejo.
3 Control de Amplitud: La amplitud de cada onda sinusoidal se puede controlar individualmente, lo que permite esculpir el timbre del sonido resultante.
*/


// Síntesis Aditiva utilizando "do"
(
SynthDef(\additiveDoSynth, {
    arg freq=440, amp=0.5, numHarm=5, dur=5;
    var signal = 0, env; // Inicializamos la señal
	env = EnvGen.kr(Env.perc(1.5, dur), doneAction:2);
    // Utilizamos "do" para sumar múltiples ondas sinusoidales
    numHarm.do { |i|
        signal = signal + (SinOsc.ar(freq * (i + 1)) * (amp / (i + 1)));
    };
	signal = signal * env;

    Out.ar(0, signal!2);
}).add;
)

x = Synth(\additiveDoSynth, [ \freq, 122, \amp, 0.5, \numHarm, 12, \dur, 10 ]);

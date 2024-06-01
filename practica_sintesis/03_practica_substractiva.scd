//básicamente de un sonido rico en armónicos, lo filtramos. Es muy común en los sintetizadores para obtener una variedad de Sonidos

/*
La síntesis substractiva se popularizó con la aparición de los primeros sintetizadores analógicos en los años 60 y 70.
Instrumentos como el Minimoog de Moog Music y el ARP 2600 de ARP Instruments utilizaron este enfoque para generar sonidos.
*/

//proceso
/*
1 Generador de Onda: Se comienza con un oscilador que produce una onda con muchos armónicos, como una onda diente de sierra o cuadrada.
2 Filtro: Esta onda se pasa a través de un filtro, que puede ser de paso bajo, paso alto, paso banda, etc. El filtro "sustrae" ciertas frecuencias del sonido original.
3 Envolvente y Modulación: Por lo general, se agregan envolventes y moduladores (como LFOs) para controlar la dinámica del sonido y agregar movimiento o variación.
*/

/*
res (q)
El argumento res en el código se refiere a la "resonancia" del filtro. La resonancia, también conocida a veces como "Q", es un parámetro que controla cuánto se enfatiza o amplifica la frecuencia alrededor del punto de corte del filtro.

En términos prácticos:

Resonancia baja: El filtro atenuará las frecuencias alrededor del punto de corte de manera suave y gradual.

Resonancia alta: Se crea un pico pronunciado o "resonancia" justo en la frecuencia de corte. Esto puede hacer que ciertas frecuencias resalten y, dependiendo de la intensidad, puede añadir un zumbido o "silbido" al sonido.

En el contexto de un filtro paso bajo (como el LPF utilizado en el código), una resonancia alta hará que las frecuencias justo por debajo del punto de corte se amplifiquen, mientras que las frecuencias por encima del punto de corte aún se atenuarán.

La resonancia es un parámetro muy útil en la síntesis substractiva. Puede darle carácter y color al sonido, y es especialmente prominente en muchos sonidos clásicos de sintetizador, como el sonido "burbujeante" de un bajo de sintetizador o el "silbido" de un filtro que se abre lentamente.






*/

//ejemplo
(
SynthDef(\simpleSubtractiveWithEnv, {
    arg freq=440, filterFreq=1000, res=0.1, amp=0.5, attack=0.01, release=4.99;
    var source, filtered, env;

	//res (q): resonancia del filtro

    // Generador de Onda
    source = Saw.ar(freq); // Onda diente de sierra

    // Envolvente Percusiva
    env = EnvGen.kr(Env.perc(attack, release), doneAction:2);

    // Filtro
    filtered = LPF.ar(source, filterFreq, res);

    // Multiplicamos la señal filtrada por la envolvente
    filtered = filtered * env;

    // Salida
    Out.ar(0, filtered * amp!2);
}).add;
)

// Para tocar el sintetizador con la envolvente
x = Synth(\simpleSubtractiveWithEnv, [ \freq, 440, \filterFreq, 100, \amp, 0.5, \attack, 0.1, \release, 4.9, \res, 0.3]);





//mas ejemplos
/*
Moog-style
Este bajo utiliza una onda diente de sierra y tiene un ataque rápido con un decaimiento corto, lo que le da un sonido pujante y definido.
El filtro tiene una frecuencia de corte baja y una resonancia moderada, lo que le da un carácter cálido y redondo.
*/
(
SynthDef(\moogBass, {
    arg freq=440, filterFreq=100, res=0.5, amp=0.5;
    var source, filtered, env;

    source = Saw.ar(freq); // Onda diente de sierra
    env = EnvGen.kr(Env.perc(0.01, 0.1), doneAction:2); // Envolvente rápida
    filtered = LPF.ar(source, filterFreq, res) * env; // Filtro con resonancia moderada
    Out.ar(0, filtered * amp!2);
}).add;
)


x = Synth(\moogBass, [ \freq, 440, \filterFr7eq, 500, \amp, 0.5, \res, 12]);

/*
Lead Acid:
Este lead utiliza una onda cuadrada con un ancho de pulso modulado. El filtro tiene una resonancia alta, lo que le da ese carácter "silbante" típico de los sonidos acid.
En el contexto del "Lead Acid" y el tipo de onda utilizado (Pulse), el pulseWidth se refiere al ancho de pulso de una onda cuadrada o de pulso.

La onda cuadrada o de pulso es una forma de onda periódica que alterna entre dos niveles. El "ancho de pulso" describe la proporción de tiempo que la onda pasa en uno de esos niveles en comparación con el otro, durante un solo período.

Un pulseWidth de 0.5 (o 50%) produce una onda cuadrada clásica, donde la onda está en su nivel alto durante la mitad del tiempo y en su nivel bajo durante la otra mitad.

Un pulseWidth diferente de 0.5 produce una onda de pulso asimétrica. Por ejemplo, con un pulseWidth de 0.2, la onda estará en su nivel alto durante el 20% del tiempo y en su nivel bajo durante el 80% del tiempo.

El ancho de pulso puede tener un efecto significativo en el timbre o carácter del sonido. Cambiar el ancho de pulso varía la cantidad y la relación de los armónicos en la señal, lo que puede resultar en sonidos más delgados o más ricos.

En muchos sintetizadores, es común modular el ancho de pulso con un LFO (oscilador de baja frecuencia) para crear un efecto de "chorus" o "phasing" conocido como "modulación de ancho de pulso" (PWM, por sus siglas en inglés). Este efecto es característico de muchos sonidos de sintetizador clásicos y es especialmente prominente en géneros como el synthwave y el trance.
*/
(
SynthDef(\acidLead, {
	arg freq=440, filterFreq=800, res=1.8, amp=0.5, pulseWidth=0.2;
    var source, filtered, env;

    source = Pulse.ar(freq, pulseWidth); // Onda cuadrada con modulación de ancho de pulso
    env = EnvGen.kr(Env.perc(0.01, 0.4), doneAction:2); // Envolvente rápida
    filtered = LPF.ar(source, filterFreq, res) * env; // Filtro con alta resonancia
    Out.ar(0, filtered * amp!2);
}).add;
)
x = Synth(\acidLead, [ \freq, 440, \filterFr7eq, 500, \amp, 0.5, \res, 12, \pulseWidth, 0.5]);

/*
Pad Espacial:
Este pad utiliza una onda diente de sierra y tiene una envolvente lenta que le da una sensación etérea y espacial.
La modulación del filtro con un LFO agrega movimiento al sonido.
*/

(
SynthDef(\spacePad, {
    arg freq=440, filterFreq=600, res=0.3, amp=0.5;
    var source, filtered, env, lfo;

    source = Saw.ar(freq); // Onda diente de sierra
    env = EnvGen.kr(Env.adsr(2, 1, 0.5, 2), doneAction:2); // Envolvente lenta
    lfo = SinOsc.kr(0.5).range(500, 700); // LFO para modulación
    filtered = LPF.ar(source, filterFreq + lfo, res) * env; // Filtro con LFO
    Out.ar(0, filtered * amp!2);
}).add;
)
x = Synth(\spacePad, [ \freq, 240, \filterFreq, 120, \amp, 0.5, \res, 0.5]);

//efectos:

/*
swoosh:
Este efecto utiliza ruido blanco y un filtro que aumenta su frecuencia de corte a lo largo del tiempo, creando un efecto "swoosh".
*/
(
SynthDef(\swooshFX, {
    arg freq=440, filterFreq=100, res=3, amp=0.5;
    var source, filtered, env, lfo;

    source = WhiteNoise.ar(); // Ruido blanco
    env = EnvGen.kr(Env.perc(0.01, 1), doneAction:2); // Envolvente rápida
    lfo = Line.kr(100, 2000, 1); // Linea ascendente
    filtered = LPF.ar(source, filterFreq + lfo, res) * env; // Filtro ascendente
    Out.ar(0, filtered * amp!2);
}).add;
)

x = Synth(\swooshFX, [ \freq, 100, \filterFreq, 220, \amp, 0.5, \res, 0.5]);


/*BAJOS PLUCKS

Este bajo tiene un carácter "plucked" o pulsado. La onda diente de sierra y la envolvente rápida le dan un ataque definido, mientras que el filtro y la resonancia le añaden cuerpo.*/
(
SynthDef(\pluckBass, {
    arg freq=440, filterFreq=400, res=0.7, amp=0.5;
    var source, filtered, env;

    source = Saw.ar(freq); // Onda diente de sierra
    env = EnvGen.kr(Env.perc(0.01, 0.1), doneAction:2); // Envolvente rápida
    filtered = LPF.ar(source, filterFreq, res) * env; // Filtro con resonancia moderada
    Out.ar(0, filtered * amp!2);
}).add;
)

x = Synth(\pluckBass, [ \freq, rrand(100, 600), \filterFreq, 220, \amp, 0.5, \res, 0.5]);







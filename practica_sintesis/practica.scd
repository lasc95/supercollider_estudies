(
SynthDef(\eightiesPad, {
    arg freq=440, dur=5, amp=0.5;
    var env, signal, chorusSig, reverbSig, delayTime;

    // Envelope
    env = Env.perc(attackTime: 2, releaseTime: 5).kr(gate: 1);

    // Oscilador
    signal = Saw.ar([freq, freq * 1.005], mul: env); // Duplicamos el oscilador con una leve desafinación para un efecto de coro natural

    // Filtro
    signal = LPF.ar(signal, freq: 1500, mul: amp);

    // Chorus usando CombL
    delayTime = LFNoise1.kr(0.2).range(0.002, 0.02);
    chorusSig = CombL.ar(signal, maxdelaytime: 0.05, delaytime: delayTime, decaytime: 0.04);

    // Reverb
    reverbSig = FreeVerb.ar(chorusSig, mix: 0.4, room: 0.7);

    // Output
    Out.ar(0, reverbSig);
}).add;
)

// Para probar
x = Synth(\eightiesPad, [freq: 440, dur: 10, amp: 0.5]);


(
SynthDef(\eightiesPadMultiVoice, {
    arg freq=440, dur=5, amp=0.5;
    var env, signal, chorusSig, reverbSig, delayTime, voices;

    // Envelope
    env = Env.perc(attackTime: 2, releaseTime: 5).kr(gate: 1);

    // Creando múltiples "voces"
    voices = 4.collect { |i|
        var detune = (i - 2) * 0.003; // pequeña desafinación entre las voces
        Saw.ar(freq * (1 + detune), mul: env)
    }.sum;

    signal = voices;

    // Filtro
    signal = LPF.ar(signal, freq: 1500, mul: amp);

    // Chorus usando CombL
    delayTime = LFNoise1.kr(0.2).range(0.002, 0.02);
    chorusSig = CombL.ar(signal, maxdelaytime: 0.05, delaytime: delayTime, decaytime: 0.04);

    // Reverb
    reverbSig = FreeVerb.ar(chorusSig, mix: 0.4, room: 0.7);

    // Output
    Out.ar(0, reverbSig * 0.5!2); // Reduzca la amplitud total para evitar la saturación
}).add;
)

// Para probar
x = Synth(\eightiesPadMultiVoice, [freq: rrand(100, 700), dur: 10, amp: 0.5]);






(
SynthDef(\eightiesArp, {
    arg freq=440, dur=5, amp=0.5;
    var env, signal, delaySig;

    // Envelope con ataque y liberación suavizados
    env = Env.perc(attackTime: 0.1, releaseTime: 0.5).kr(gate: 1);

    // Oscilador
    signal = Pulse.ar(freq, width: 0.4, mul: env);

    // Filtro
    signal = LPF.ar(signal, freq: 2000, mul: amp);

    // Delay para un efecto espacioso usando CombN
    delaySig = CombN.ar(signal, maxdelaytime: 0.5, delaytime: 0.125, decaytime: 0.5);

    // Output
    Out.ar(0, delaySig);
}).add;
)

// Generar una secuencia de 5 notas aleatorias
(
~randomNotes = Pfunc {
    Pseq((1..5).collect {
        [220, 246.94, 277.18, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88].choose
    }, inf)
};
)
// Para probar
(
Pbind(
    \instrument, \eightiesArp,
    \freq, ~randomNotes,
    \dur, 0.75,  // Aumentamos el tiempo de duración de cada nota
    \amp, 0.3
).play;)




(
SynthDef(\spaceAmbientPad, {
    arg freq=440, amp=0.5, reverbAmount=0.5;
    var env, signal, reverbSig;

    // Envelope
    env = Env.linen(attackTime: 10, sustainTime: 5, releaseTime: 10).kr(gate: 1);

    // Oscilador
    signal = Saw.ar(freq, mul: env);

    // Filtro para suavizar el sonido
    signal = LPF.ar(signal, freq: 1000, res: 0.5);

    // Añadir reverb para un efecto espacioso
    reverbSig = FreeVerb.ar(signal, mix: reverbAmount, room: 0.9, damp: 0.2);

    // Output
    Out.ar(0, reverbSig * amp);
}).add;
)

// Para probar el pad
x = Synth(\spaceAmbientPad, [freq: 440, amp: 0.7, reverbAmount: 0.5]);



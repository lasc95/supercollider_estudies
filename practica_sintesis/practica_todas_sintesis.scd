//practica todas las sintesis

/*
Síntesis Am

*/
(
SynthDef.new(\my_am, {
	arg freqCarrier=400, freqModulator=20, amp=0.3, modIndex=1;
	var finalSignal, carrier, mod, env;
	mod = SinOsc.ar(freqModulator) * modIndex;
	carrier = SinOsc.ar(freqCarrier);
	finalSignal = (carrier * (mod + 1)) * amp;
	Out.ar(0, finalSignal!2);

}).add;
);

Synth(\my_am,[\freqModulator,5120])



//sintesis fm

(
SynthDef.new(\my_fm,{
	arg modFreq=300, carrFreq=400, modIndex=1, amp=0.6;
	var carrier, mod, env;
	 env = EnvGen.kr(Env.perc(0.4, 10), doneAction:2);
	mod = SinOsc.ar(modFreq) * modIndex;
	carrier = SinOsc.ar(carrFreq + mod) * amp * env;
	Out.ar(0, carrier!2);
}
).add;
)

Synth(\my_fm, [\modFreq, 900, \carrFreq,400, \modIndex, 123]);


//Sintesis Aditiva

(
SynthDef.new(\my_add, {
	arg freqBase=400, amp=0.2, numHarm=2, dur=2;
	var signal=0, env;
	env = EnvGen.kr(Env.perc(1.5, dur), doneAction:2);
	numHarm.do{|i|
		signal = signal + (SinOsc.ar(freqBase * (i +3)) );
		signal.postln;
	};
	signal = signal * env;
	Out.ar(0, signal!2);
}).add;
)

Synth(\my_add, [\numHarm, ]);

//sintesis substractiva

(
SynthDef.new(\my_sub,{
	arg dur=4, freq=300, rq=0.1, cutFreq=300;
	var env, signal;
	env = EnvGen.kr(Env.perc(0.5, dur), doneAction:2);
	signal = LFNoise1.ar(freq, 0.4);
	signal = BPF.ar(signal, cutFreq, rq);
	signal = signal * env;
	Out.ar(0, signal!2);
}).add;
)

Synth(\my_sub, [\freq, 500, \rq, 0.01, \dur, 10]);


// Sintesis Granular

(
var winenv, z; //esta es la envolvente para cada grano
winenv = Env([0, 1, 0], [0.2, 0.2], \lin);

//convertimos a discreto
z = Buffer.sendCollection(s, winenv.discretize, 1);

SynthDef.new(\my_gran, {
	arg out, gate=1, amp=0.8, envBuf;
	var pan, env, freqDev;

	pan = MouseX.kr(-1, 1);

	freqDev = WhiteNoise.kr(MouseY.kr(0, 600));

	env = EnvGen.kr(Env([0, 1, 0], [1, 1], \sin, 1), gate, levelScale:amp, doneAction:Done.freeSelf);

	Out.ar(out,
		GrainFM.ar(2,
			Impulse.kr(10),
			0.1,
			440 + freqDev,
			200,
			LFNoise1.kr.range(1, 10),
			pan,
			envBuf) * env);
}).add;

)//fin todo

x = Synth(\my_gran, [\envBuf, z])

x.set(\gate, 0)

s.scope;






// Define un nuevo SynthDef llamado \espacial.
(
SynthDef.new(\espacial, {
	// Argumentos con valores predeterminados para el SynthDef.
	arg amphz = 4, fund = 40, maxPartial = 4 , width = 0.5, dur;
	var amp1 , amp2, freq1, freq2, sig1, sig2, sig3, env, pan;

	// Genera una envolvente que se utiliza para controlar el nivel general del sonido.
	env = EnvGen.kr(Env.new([0, 0.7, 0], [1, dur], curve:\sine),doneAction:2);

	// Genera dos señales de pulso de baja frecuencia para controlar las amplitudes de dos osciladores de pulso.
	amp1 = LFPulse.kr(amphz,0, 0, 0.12) * 0.75;
	amp2 = LFPulse.kr(amphz,0, 0.5, 0.12) * 0.75;

	// Genera dos frecuencias de ruido que cambian lentamente y las redondea al múltiplo más cercano de 'fund'.
	freq1 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq2 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);

	// Modula las frecuencias con señales de pulso de baja frecuencia para crear variaciones rítmicas.
	freq1 = freq1 * LFPulse.kr(8,add:1);
	freq2 = freq2 * LFPulse.kr(6, add:1);

	// Crea dos osciladores de pulso con las frecuencias y amplitudes moduladas.
	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp2);

	// Aplica reverberación a las dos señales de pulso.
	sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);

	// Mezcla las dos señales y las multiplica por la envolvente.
	sig3 = (sig1 + sig2) * env;

	// La señal final se mantiene en 'pan' pero sin aplicarle panoramización.
	pan = sig3;

	// Envía la señal de audio a las salidas estéreo.
	Out.ar(0, pan);
	Out.ar(1, pan);

	// Imprime la duración para fines de depuración.
	dur.postln;
}).add // Añade la definición del sintetizador al servidor de sonido para que pueda ser utilizado.

)

s.boot;


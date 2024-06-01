/*
Historia
La síntesis granular tiene sus raíces en las ideas propuestas por el compositor Iannis Xenakis en los años 50 y 60. Xenakis conceptualizó un enfoque de composición basado en la manipulación de pequeños sonidos o "granos" para crear estructuras musicales más grandes, un proceso que él llamó "musique stochastique" (música estocástica). Las primeras implementaciones prácticas de estas ideas comenzaron a aparecer en la década de 1970 con la obra de Curtis Roads y Barry Truax, quienes fueron pioneros en el uso de la síntesis granular en composiciones musicales y en el desarrollo de software para su creación.

Cómo Funciona
La síntesis granular trabaja dividiendo un sonido en pequeñas partes o "granos" que pueden tener desde unos pocos milisegundos hasta aproximadamente 50 milisegundos de duración. Estos granos se pueden manipular individualmente en términos de pitch, volumen, duración, panorama y espaciado temporal. La superposición y secuenciación de estos granos en el tiempo crean nuevas texturas sonoras.

La síntesis granular puede ser controlada de manera determinista, donde cada parámetro de cada grano es cuidadosamente definido, o de manera estocástica, donde los parámetros de los granos se generan utilizando procesos aleatorios o probabilísticos.

Lo Práctico
En la práctica, la síntesis granular se utiliza para:

1 Crear texturas y paisajes sonoros complejos.
2 Procesar sonido de manera no destructiva, permitiendo transformaciones que van desde sutiles hasta extremas.
3 Generar sonidos ambientales y efectos especiales para cine y videojuegos.
4 Extender y transformar muestras musicales.

grainbuf:
En SuperCollider, GrainBuf es una unidad generadora (UGen) utilizada para la síntesis granular que lee pequeños segmentos de un buffer de sonido. Aquí te explico cada uno de los parámetros que esta UGen puede recibir:

numChannels: Especifica el número de canales de salida. Si usas un buffer monoaural, puedes seguir teniendo una salida estéreo si estableces numChannels en 2.

trigger: Es la señal que dispara la creación de un nuevo grano. Por lo general, se usa una señal de impulso (Impulse.kr) con una frecuencia que determina cuán a menudo se generan los granos.

dur: Es la duración de cada grano en segundos. Este valor puede ser constante o puede variar a lo largo del tiempo si se modula con otra UGen.

sndbuf: Es el número de índice del buffer que contiene el sonido que se va a granular. Debes cargar un sonido en un buffer y luego pasar ese buffer a GrainBuf.

rate: Controla la velocidad de reproducción de cada grano. Un rate de 1 reproduce el sonido a velocidad normal, valores mayores a 1 aumentan la velocidad (y por ende, el tono), y valores menores a 1 la disminuyen. Valores negativos harán que el grano se reproduzca hacia atrás.

pan: Determina la posición estéreo de cada grano. Un valor de 0 coloca el sonido en el centro, -1 a la izquierda completamente, y 1 a la derecha completamente.

pos: Es la posición inicial dentro del buffer desde donde se comienza a leer el grano. Puede ser un número fijo o una UGen que varíe a lo largo del tiempo, permitiendo así barrer diferentes partes del buffer.

interp: Especifica el tipo de interpolación que se debe usar cuando se leen muestras entre los índices del buffer. Una interpolación más alta puede reducir artefactos audibles pero consume más CPU.

envbufnum (opcional): Es el índice de un buffer que contiene una forma de onda de envolvente que se aplicará a cada grano. Si no se especifica, se usará una envolvente predeterminada.

maxGrains (opcional): Es el máximo número de granos que pueden sonar al mismo tiempo.

Es importante tener en cuenta que los parámetros como pan, pos, y rate pueden ser modulados en tiempo real para crear efectos interesantes y dinámicos en la textura sonora. Además, el uso de envbufnum permite controlar la forma en que cada grano se desvanece dentro y fuera, lo que puede tener un gran impacto en la calidad del sonido granular resultante.

*/

s.boot; // Asegúrate de que el servidor está corriendo.
(
// Crear una variable local para almacenar la forma de la envolvente personalizada.
var winenv; //esta es para cada grano

// Definir la envolvente personalizada con tres niveles y dos tiempos de transición.
// La envolvente comienza en 0, sube a 1 en 0.5 segundos, y luego vuelve a 0 en 0.5 segundos.
// Las curvas entre los niveles son exponenciales, 8 para subir y -8 para bajar.
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);

// Convertir la envolvente a una colección de datos discretos y enviarla a un Buffer en el servidor.
// Este buffer se utilizará luego para controlar la amplitud de la síntesis granular.
z = Buffer.sendCollection(s, winenv.discretize, 1);

// Definir un SynthDef con el nombre \fm_grain_test.
SynthDef(\fm_grain_test, { |out, gate = 1, amp = 1, envbuf|
    // Declarar las variables locales para el panorama, la envolvente y la desviación de frecuencia.
    var pan, env, freqdev;

    // Controlar el panorama estéreo con la posición horizontal del ratón, de -1 a 1.
    pan = MouseX.kr(-1, 1);

    // Generar ruido blanco para la desviación de frecuencia y controlar la cantidad con la posición vertical del ratón.
    freqdev = WhiteNoise.kr(MouseY.kr(0, 400)); // moduladora que se va moviendo entre 0 y 400 solamente para afectar a la portadora

    // Generar una envolvente de amplitud que sube y baja en 1 segundo,
    // usando una forma sinusoidal (\sin) para la transición entre los niveles.
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp, // Escalar la envolvente por el argumento amp.
        doneAction: Done.freeSelf); // Liberar el Synth cuando la envolvente termine.

    // Generar la señal de audio utilizando GrainFM para síntesis granular de modulación de frecuencia.
	// Se utiliza un Impulse.kr(10) como el gatillo para los granos, a 10 Hz. (ciclos por segundo, es decir, se harán 10 impulsos cada segundo)
    // La duración de cada grano es 0.1 segundos, la frecuencia central es 440 Hz más la desviación del ruido blanco,
    // y la frecuencia de modulación es controlada por un LFNoise1.kr que varía entre 1 y 10 Hz.
    // El argumento envbuf se pasa para usar el buffer de envolvente enviado previamente.
    // La salida final se escala por la envolvente generada por EnvGen.
    Out.ar(out,
        GrainFM.ar(2,
			Impulse.kr(10),
			0.1,
			440 + freqdev,
			200,
			LFNoise1.kr.range(1, 10),
            pan,
			envbuf)
		* env)
}).add; // Agregar el SynthDef al servidor para que esté listo para su uso.

)

// use built-in env
x = Synth(\fm_grain_test, [\envbuf, -1])

// switch to the custom env
x.set(\envbuf, z)
x.set(\envbuf, -1);

x.set(\gate, 0);


/*ENVOLVENTES:
Envoltura de Amplitud (env):

La primera envolvente, creada por EnvGen.kr(...), es una envoltura de control, probablemente usada para la amplitud general del sonido. Esta envoltura determina cómo el volumen del sonido se modula con el tiempo; comienza en silencio, aumenta a un máximo, y luego vuelve a silencio. Esta forma de modulación de volumen es común en instrumentos y sintetizadores para simular la manera en que los sonidos naturales se elevan y decaen.
Buffer de Envoltura para la Síntesis Granular (envbuf):

La segunda envolvente es la que se envía a un Buffer y se utiliza específicamente para la síntesis granular (GrainFM.ar(...)). En la síntesis granular, cada "grano" de sonido puede tener su propia envoltura que determina cómo cambia su amplitud durante su breve existencia. El buffer de envoltura es probablemente un conjunto de valores discretos que representan una envoltura que se aplica a cada grano individual.
La razón por la que se utilizan dos envolturas es que tienen funciones diferentes en la generación de sonido:

La envoltura de amplitud modula el volumen general del sintetizador con el tiempo, lo que afecta a todo el sonido producido por el Synth. Esta es una práctica común en la síntesis de sonido para darle forma a la "dinámica" del sonido completo.

La envoltura en el buffer se usa para dar forma a cada grano individual dentro de la síntesis granular. Cada grano puede ser muy corto, y esta envoltura determina cómo entra y sale cada uno de estos sonidos, lo que puede afectar la textura y la calidad del sonido final.

Así, mientras la envoltura global de amplitud afecta el sonido completo a lo largo del tiempo, la envoltura por grano afecta cada pequeña unidad de sonido que compone la textura general que estás escuchando. La combinación de ambas permite un control detallado sobre la dinámica y textura del sonido producido por el sintetizador.


*/


//mi granular
var winenv;

//creamos la envolvente
/*
argumentos de Env:
niveles: de 0 a 1 y luego a 0
tiempo: siempre uno menos que los niveles, dee 0 a 1 pasa en 0.5 sg, lo mismo al revés
niveles de curva: igual uno menos a los niveles. en este caso 8, de 0 a 1 irá en una curva precipitada. luego baja drásticamente
todos los parámetros luego de los niveles dependerán de qué cantidad de niveles tenga, menos 1.
*/
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);


//convertimos la envolvente a discreto y la almacenamos en un buffer
/*
Buffer: sirven para manipular señales de audio, pero no solamente eso
Buffer.sendCollection: se usa para enviar una colleción de datos, en este caso, para una envolvente que se utilizará a lo largo del tiempo (puede ser cualquier serie de valores que controle señales en el transcurso del tiempo
winenv.discretize: mi envolvente es una envolvente continua, el computador solo lee datos discretos, por lo que debo discretizarlo para que forme un mapeo de numeros que pueda
ser leído por sc.
Plotearla
(
var winenv;
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
winenv.plot;
)
*/
z = Buffer.sendCollection(s, winenv.discretize, 1);

(
var winenv, otra;
winenv = Env([0, 1, 0], [0.5, 0.5], [8, 8]);
winenv.plot;
)




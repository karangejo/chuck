// Additive Modal Synthesis using BiQuad ResonZ filter
//    to resynthesize the plinked Plate sound
// by Perry R. Cook, 2015

// You can use this as a model to do your own
//  Modal synthesis.  More modes, fewer modes,
// it's all good.  Listen, and...  Experiment!!

// Modal Resynthsis Class, uses ResonZ filters for modes
class ModalSynth extends Chubgraph {
    16 => int NUM_MODES;
    ResonZ modes[NUM_MODES];

//     frequency  ,  gain  (could add time constant here too)
    [[ 3861.328125 , 0.228562 ],
    [ 3946.289062 , 0.227689 ],
    [ 3993.164062 , 0.250946 ],
    [ 3796.875000 , 0.069848 ],
    [ 4040.039062 , 0.041380 ],
    [ 3333.984375 , 1.000000 ],
    [ 3747.070312 , 0.058183 ],
    [ 4086.914062 , 0.054205 ],
    [ 5255.859375 , 0.852049 ],
    [ 6216.796875 , 0.307419 ],
    [ 3697.265625 , 0.063957 ],
    [ 3609.375000 , 0.018932 ],
    [ 3559.570312 , 0.039833 ],
    [ 3380.859375 , 0.023377 ],
    [ 7174.804688 , 0.452911 ],
    [ 4286.132812 , 0.339927 ]]  // which you can change if you like!
     @=> float freqsNamps[][];

//    You could fill this array with measured or guess-timated time constants
// [ 2.0, 1.9, 1.8, 1.7, 1.6, 1.5, 1.4, 1.3, 1.2, 1.1 ] @=> float T60s[];
//   or build them in as a third number for each entry above
//   see code below on how to use them.

// use this for residual (or other wave file) excitation
//     NOTE:   See residue file note above

// Use this for enveloped noise excitation
Noise n => ADSR excite;
(samp,10::ms,0.0,ms) => excite.set;

// Or use this for an impulse excitation
//  Impulse imp => Gain excite
// // when you want to excite it, do:  100*vel => imp.next; // or some scaled version

// might have to fiddle with this some, depends on modes and excitation
    50.0 => excite.gain;

    for (int i; i < NUM_MODES; i++)  {
        excite => modes[i] => dac;
        freqsNamps[i][0] => modes[i].freq; // frequencies from
        // set these automatically here, you can do better
        setQfromT60(1.0-i/NUM_MODES,freqsNamps[i][0]) => modes[i].Q;
        freqsNamps[i][1] => modes[i].gain;
    }

    fun float setQfromT60 (float tsixty, float centerFreq)  {
        Math.pow(10.0,-3.0/(tsixty*second/samp)) => float rad;
        Math.log(rad) / -pi / (samp/second) => float BW;
        centerFreq / BW => float Q;
//        <<< "BW is", BW, "Q is", Q >>>;
        return Q;
    }

    fun void whackIt()  {
//        <<< modes[0].gain(), modes[1].gain(), modes[2].gain(), modes[3].gain(), modes[4].gain() >>>;
        1 => excite.keyOn; // for enveloped noise excitation
    }

    fun void whackItRandom(float vel)  {
        for (int i; i < 10; i++)  {  // randomize the mode gains a bit
            vel*Math.random2f(freqsNamps[i][1]/2,2*freqsNamps[i][1]) => modes[i].gain;
        }
        whackIt();
    }

    fun void whackIt(float vel)  {
        for (int i; i < 10; i++)  {  // assume lots about spatial modes
            vel*Math.random2f(freqsNamps[i][1]/2,2*freqsNamps[i][1]) => modes[i].gain;
        }
        whackIt();
    }

    // overloaded function uses position (0-1.0) for mode gains
    //   makes gross assumption that modes are 1D spatial modes
    fun void whackIt(float vel, float position)  {
        for (int i; i < NUM_MODES; i++)  {
            freqsNamps[i][0] => modes[i].freq;
            Math.sin(pi*(i+1)*position) => float temp;
            vel*temp*freqsNamps[i][1] => modes[i].gain;
        }
        whackIt();
     }

     fun void whackIt(float pitch, float velocity, float position)  {
         for (int i; i < NUM_MODES; i++)  {
             pitch*freqsNamps[i][0] => modes[i].freq;
             Math.sin(pi*(i+1)*position/NUM_MODES) => float temp;
             velocity*temp*freqsNamps[i][1] => modes[i].gain;
         }
         whackIt();
     }

 }

ModalSynth plate;

plate.whackIt();

3*second => now;
for (1 => int i; i < 11; i++) { // test "strike position" function
    plate.whackIt(0.5,i/20.0);  // move along "length" of bar (if it were a bar)
    <<< "Whack it at:", i/20.0 >>>;
    second => now;
}
second => now;

// now try out some pitch transpositions for a bit

now + 10::second => time then;

while (now < then)  {
    plate.whackIt(Math.random2f(0.7,1.6), 0.5, 0.34159);
    (Math.random2f(1,3)*0.3)::second => now;
}

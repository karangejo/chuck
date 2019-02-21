//  One bird tweeter
//     by Perry R. Cook, (1996-) 2015
// SinOsc thru envelope thru reverb into dac

public class Tweet extends Chubgraph {
    SinOsc s => ADSR a => Pan2 p => dac;
    (40*ms,second/10,0.0,ms) => a.set;

    Math.random2f(0.6,2.5) => float tempo; // each bird is
    Math.random2f(4500,6000) => float freq; // different
    Math.random2f(-1.0,1.0) => p.pan; // as are we
    
    fun void tweet()  {
        Math.random2f(0.9*freq,1.1*freq) => s.freq;
        1 => a.keyOn;
        while (s.freq() > 100.0)  {
            s.freq()*0.995 => s.freq;
            ms => now;        
        }
	1 => a.keyOff;
        Math.random2f(0.95*tempo,1.05*tempo) :: second => now;
    }
}

Tweet tw => dac;  // tween once to test
tw.tweet();



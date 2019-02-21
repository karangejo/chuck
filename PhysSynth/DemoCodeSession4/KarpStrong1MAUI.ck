 // Basic Karplus Strong Plucked String Synthesis Model
//    by Perry R. Cook, July 2015
// Noise into feedback delay (collapsed Left/Right waveguide),
// with 2-pt moving average lowpass loop filter
// Simple GUI in MAUI for control

class KarplusStrong1 extends Chubgraph {
// Noise thru envelope through string into filter into dac
    Noise n => ADSR plk => DelayA strng => OneZero loop => dac;
    loop => strng;                // hook delay back to itself
    second/50 => strng.max;       // 50 Hz. is lowest frequency we expect
    (ms,10*ms,0.0,ms) => plk.set; // set noise envelope
    100.0 => float frq; // initial frequency
    10.0 => float sust; // in seconds
    sustain(sust);
    second/frq => strng.delay;   // delay time is 1.0/freq seconds 
    
    fun void pluck(float note, float vel)  {
        Std.mtof(note) => frq;
        ((second / samp) / frq - 1) => float period;
        (samp,period::samp,0.0,samp) => plk.set;
        period::samp => strng.delay;
        vel => n.gain;
        1 => plk.keyOn;
    }
    
    fun void sustain(float aT60)  {
        aT60 => sust;
        Math.exp(-6.91/sust/frq) => loop.gain;
    }    
}

MAUI_View myWinder; MAUI_Button pickIt; MAUI_Button exit; 
MAUI_Slider sstane; MAUI_Slider noteNum; MAUI_Slider velocity;
doGUI();

KarplusStrong1 ks => dac;

spork ~ hangForPluck();
spork ~ hangForSust();

ks.pluck(60,0.6);

while (!exit.state())  {
    ms => now;
}

myWinder.destroy();

fun void hangForPluck()  {
    while (true) {
        pickIt => now;
        if (pickIt.state()) ks.pluck(noteNum.value(), velocity.value());
    }
}    

fun void hangForSust()  {
    while (true) {
        sstane => now;
        ks.sustain(sstane.value());    
    }
}    

fun void doGUI()  {
    myWinder.name("Karp!! Basic"); myWinder.size(240,220);
    pickIt.size(100,70);
    exit.size(100,70); exit.position(140,0); 
    noteNum.range(40,90);noteNum.position(0,60);noteNum.value(60);
    velocity.range(0.0,1.0); velocity.position(0,100); velocity.value(0.5);
    sstane.range(0.0,50.0); sstane.position(0,140); sstane.value(10.0);
    myWinder.addElement(noteNum);  noteNum.name("Note Number");
    myWinder.addElement(sstane);   sstane.name("Sustain (time)");
    myWinder.addElement(velocity); velocity.name("Velocity");
    myWinder.addElement(exit); exit.name("Exit"); 
    myWinder.addElement(pickIt); pickIt.name("Pluck!"); 
    myWinder.display();
}


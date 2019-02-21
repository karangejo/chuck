// Improved Karplus Strong Plucked String Synthesis Model
//    by Perry R. Cook, July 2015
// Noise into feedback delay (collapsed Left/Right waveguide),
// with 3-pt FIR lowpass loop filter (brightness)
// Simple GUI in MAUI (Mac only) for control

class KarplusStrong2 extends Chubgraph {
    Noise n => ADSR plk => DelayA strng => TwoZero loop => dac;
    loop => strng;
    10.0 => float sust; // in seconds
    0.5 => float brite; // 0.0 to 1.0
    330.0 => float frq;
    
    second/50 => strng.max; // 50 Hz lowest frequency
    
    fun void freq(float frequency)  {
        frequency => frq;
        ((second / samp) / frequency - 1) => float period;
        (ms,period::samp,0.0,ms) => plk.set;
        period::samp => strng.delay;        
    }
    
    fun void bright(float brightness)  {
        brightness => brite;
        loop.gain()*(1-brite)/4 => loop.b0;
        loop.gain()*(1-brite)/4 => loop.b2;
        loop.gain()*(1+brite)/2 => loop.b1;
    }
    
    fun void sustain(float aT60)  {
        aT60 => sust;
        Math.exp(-6.91/sust/frq) => loop.gain;
    }
    
    fun void pluck(float note, float velocity)  {
        Std.mtof(note) => freq;
        bright(brite); // reset parameters given delay length
        ((second / samp) / frq - 1) => float period;
        (ms,period::samp,0.0,ms) => plk.set;
        period::samp => strng.delay;
        velocity => n.gain;
        1 => plk.keyOn;
    }
}

MAUI_View myWinder; MAUI_Button pickIt; MAUI_Button exit; 
MAUI_Slider sstane; MAUI_Slider noteNum; MAUI_Slider brit; 
MAUI_Slider velocity;
doGUI();

spork ~ hangForPluck();
spork ~ hangForBrite();
spork ~ hangForSustain();

KarplusStrong2 ks;

ks.pluck(60,0.6);

while (!exit.state())  {  // just hang here until exit
    30*ms => now;
}

myWinder.destroy();

fun void hangForSustain()  {
    while (true) {
        sstane => now;
        ks.sustain(sstane.value());
    }
}    

fun void hangForPluck()  {
    while (true) {
        pickIt => now;
        if (pickIt.state()) ks.pluck(noteNum.value(),velocity.value());
    }
}    

fun void hangForBrite()  {
    while (true) {
        brit => now;
        ks.bright(brit.value());
    }
}    

fun void doGUI()  {
    myWinder.name("Karp!!"); myWinder.size(240,260);
    pickIt.size(100,70);
    exit.size(100,70); exit.position(140,0); 
    noteNum.range(40,90);noteNum.position(0,60);noteNum.value(60);
    velocity.range(0.0,1.0); velocity.position(0,100); velocity.value(0.5);
    sstane.range(0.0,40.0); sstane.position(0,140); sstane.value(20);
    brit.range(0.0,1.0); brit.position(0,180); brit.value(0.5);
    myWinder.addElement(noteNum); noteNum.name("Note Number");
    myWinder.addElement(sstane);  sstane.name("Sustain (seconds)");
    myWinder.addElement(brit);    brit.name("Brightness");
    myWinder.addElement(velocity); velocity.name("Velocity");
    myWinder.addElement(exit); exit.name("Exit"); 
    myWinder.addElement(pickIt); pickIt.name("Pluck!"); 
    myWinder.display();
}


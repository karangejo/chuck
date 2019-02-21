//@title Chuck-o-der
//@Author - Orchisama Das, Music 220A final project, 2016
//https://ccrma.stanford.edu/~orchi/220a/final_project/newVocoder.ck


//@descripton - A humble vocoder, that is built upon the works of Nick Gang and Gio Jacuzzi who
//first tried this in ChucK. This version is standalone and also adds a midi synthesizer component.
//A midi keyboard can be used to play polyphonic FM sounds. The magnitude spectrum of the microphone input determines
//the spectrum of each synthesizer voice. The inverse fft of each synthesizer voice after processing sonifies the vocal processor.
//Midi controllers also control the FM parameters and can be adjusted to give a wide range of sounds.
//I didn't use any effects, because I liked the raw sound from the keyboard and vocoder. Adding polyphony
//introduced a lot more harmonics to the processed vocal sound, making it more interesting.

//connect mic input to FFT through a DC blocker
adc => PoleZero dcblock_in => FFT mic_fft => blackhole;
//connect inverse FFT through DC blocker and gain UGen to dac
PoleZero dcblock_out;
Gain gain_out;

//set polezero position of DC blocker
0.999 => dcblock_in.blockZero;
0.999 => dcblock_out.blockZero;
0.2 => gain_out.gain;

//Polyphonic FM synth
10 => int maxVoices;
//change this line to whatever FM instrument you like
BeeThree synth[maxVoices];
FFT synth_fft[maxVoices];
IFFT out_ifft[maxVoices];


for(0 => int i; i< maxVoices; i++){
    synth[i] => synth_fft[i] => blackhole;
    out_ifft[i] => dcblock_out => gain_out => dac;
    //to also hear synth, uncomment the following lines
    //synth[i] => dac;
    //0.1 => synth[i].gain;
}

int id[maxVoices];//an array to hold the note numbers so that we can match them up with the off signal
int  counter;

public void playSynth(int note, int vel, int pos){
    //<<<note, vel>>>;
    Std.mtof(note) => synth[pos].freq;
    Math.log(vel)/2 => synth[pos].noteOn;
}

public void stopSynth(int pos){
    0 => synth[pos].noteOn;
}

public void changeFMDepth(int depth){
    for(0 => int i; i< maxVoices; i++)
        depth/128.0 => synth[i].lfoDepth;
}

public void changeFMModulation(int speed){
   for(0 => int i; i< maxVoices; i++)
      (speed/128.0) * 5 => synth[i].lfoSpeed;
}


//midi setup
//my midi keyboard is in port 1
1 => int device;

MidiIn min;
MidiMsg msg;

//Print out MIDI device name to make sure it's the right one
if( !min.open( device ) ) me.exit();
<<< "MIDI device: ", min.num(), "->", min.name() >>>;

fun void midiSynth(){

while( true ){
   // wait on your midi event
   10::ms => now;

	//this processes the keypresses
  while( min.recv( msg ) ){

     if( msg.data1 == 144){ //note on?
	  	0=> counter;         //initialize the counter

	  	while(id[counter]!=0) //this looks for an empty position in the array
	   	    counter++;

	    msg.data2=>id[counter]; //puts the midi key number into the id array

        //call play function here
	  	playSynth(id[counter],msg.data3,counter);
      }

      //use CC#1 and CC#2 to control FM parameters
      //the midi numbers are specific to the particular keyboard I am using
      else if(msg.data1 > 144){
          <<<msg.data1, msg.data2, msg.data3>>>;
          if(msg.data1 == 176 && msg.data2 == 71)
              changeFMModulation(msg.data3);
          else if(msg.data1 == 176 && msg.data2 == 72)
              changeFMDepth(msg.data3);
      }


	  if( msg.data1 == 128){//note off?
	  	0=>counter;

 	  while(id[counter]!=msg.data2)//looks for the counter position of the note that turned off
 	  	counter++;

	 stopSynth(counter);        //OFF!!!!!
     0=>id[counter];            //changes the id of the note just turned off to zero for re-use
      }
     }
 }
 }

 fun void vocoder(){
     //the plan here is to calculate take the magnitude spectrum of each synth voice individually and change it according to the mic input

     //initialise fft size, window size, hop size
     512 => int FFT_SIZE => mic_fft.size;
     FFT_SIZE/2 => int WIN_SIZE;
     WIN_SIZE/2 => int HOP_SIZE;
     for(0 => int i; i < maxVoices; i++){
         FFT_SIZE => synth_fft[i].size => out_ifft[i].size;
         Windowing.hann(WIN_SIZE) => synth_fft[i].window => out_ifft[i].window;
     }

     Windowing.hann(WIN_SIZE) => mic_fft.window;
     complex spectrum_synth[WIN_SIZE];
     complex spectrum_mic[WIN_SIZE];
     polar temp_polar_synth;
     polar temp_polar_mic;


     while(true){

         //modulate magnitude spectrum of FMSynth with mic input
          mic_fft.upchuck();
          mic_fft.spectrum(spectrum_mic);


          for(0 => int i; i < maxVoices; i++){
             synth_fft[i].upchuck();
             synth_fft[i].spectrum(spectrum_synth);
             for(0 => int j; j < WIN_SIZE;j++){
                 spectrum_synth[j]$polar => temp_polar_synth;
                 spectrum_mic[j]$polar => temp_polar_mic;

                 temp_polar_mic.mag => temp_polar_synth.mag;
                 temp_polar_synth$complex => spectrum_synth[j];
             }
             out_ifft[i].transform(spectrum_synth);
             //the next if statement is VERY important
             //if there are no midi messages associated with a voice, chuck gives it a
             //default frequency of 220Hz, which overpowers all other voices, and what
             //we hear is a constant vocoder sound not changing pitch when you change   	     //notes on the MIDI keyboard.
             if(id[i] == 0)
                 0 => out_ifft[i].gain;
             else
                 0.3 => out_ifft[i].gain;
         }
             HOP_SIZE :: samp => now;

     }
 }

 spork ~ midiSynth();
 spork ~ vocoder();
 while(true){
     1::second => now;
 }

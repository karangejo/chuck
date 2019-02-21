// Simple Mono Mandolin Synthesizer controlled by MIDI Input
//  You must have some MIDI device available to control this.
///     To see devices available, if any:
//  In miniAudicle:  Window > Device Browser > MIDI > Input
//  From command line: chuck --probe

// Setup MIDI input, set a port number, try to open it 

MidiIn min;  	// MIDI input object
0 => int port;  // device number to open

if( !min.open(port) )  	// open the port, fail gracefully
{
    <<< "Error: MIDI port did not open on port: ", port >>>;
    me.exit(); 
}

MidiMsg msg;	// MIDI message holder

Mandolin mando => dac;	//  Mandolin to play from MIDI

while( true )	{	// loop
    min => now;     // hang here waiting for MIDI
   
    while( min.recv(msg) )  { // process message(s)
        <<< msg.data1, msg.data2, msg.data3 >>>;
        if (msg.data1 == 144)  { // noteOn, channel 0 (1)
            Std.mtof(msg.data2) => mando.freq; // pitch from MIDI#
            msg.data3/127.0 => mando.noteOn;  // velocity
        }
        else  {
            1 => mando.noteOff;
        }
    }    
}


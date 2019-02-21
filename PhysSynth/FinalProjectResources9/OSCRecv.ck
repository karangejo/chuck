// Simple Open Sound Control Receiver
//  by Perry R. cook, 2015

OscIn oin;    // Make a new OSC receiver object
6449 => oin.port; // set port number (very important!!!)

OscMsg msg;	  // make an incoming message holder

// Message prefix is completely your choice 
//  (but remember it, sender needs to send this exactly)
oin.addAddress( "/realDSPOSCSender/OSCNote" );

// Make a synthesizer to respond to incoming messages/parameters
Mandolin mando => dac;

// Infinite loop to wait for messages and play notes
while (true)   {
    // OSC message is an event, chuck it to now
    oin => now;
   
    // when event(s) received, process them
    while (oin.recv(msg) != 0)  {
        // retrieve integer, float, string from message
        msg.getInt(0) => int note;
        msg.getFloat(1) => float velocity;
        msg.getString(2) => string message;
       
        // sonify our success with music!!
        Std.mtof(note) => mando.freq;
        velocity => mando.noteOn;
       
        //  print it all out
        <<< message, note, velocity >>>;
    }
}


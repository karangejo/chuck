// Simple Open Sound Control Sender Example
//  by Perry R. cook, 2015

OscOut xmit;    // Make a new OSC sender object
6449 => int port; // set port number (important to remember this!!)

// NOTE: we could specify an IP address or published LAN hostname
//  xmit.dest ( "192.168.88.214", port ); // open on numbered IP address
//  xmit.dest ( "beavis.local", port ); // open on LAN host name
xmit.dest ( "localhost", port ); // open on local host

// infinite time loop
while( true )    {
    // Message prefix is completely your choice 
    //  (but remember it, receiver needs to listen for this exactly)
    xmit.start( "/realDSPOSCSender/OSCNote" );

    // Create some data to send
    48+2*Math.random2(0,12) => int note;  // random MIDI note number to send
    Math.random2f(0.1,1.0) => float velocity; // random velocity
    "Physics rocks!!" => string message; // just here for testing
    
    note => xmit.add;       // add integer note# to message
    velocity => xmit.add;   // add float velocity to message
    message => xmit.add;	// add string to message

    xmit.send();			// Ship it!!

    // hang a bit, then do it again
    0.2 :: second => now;
}


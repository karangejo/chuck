Hey there!!  Welcome to Demo Code for Session 4
Physics-Based Synthesis for Games and Interactive Systems
Perry R. Cook, Stanford CCRMA/Kadenze, 2015

Cool simulations/solutions/animations in Processing:

StringFDM		Finite Difference String Model (curvature->accel->vel->pos)
FourierHarmString 	Fourier additive sine model of string
DAlembertString   	D'Alembert (waveguide) model of string
DAlembertOpenClosedTube Closed/Open tube D'Alembert simulation

ChucK stuff:

AdditiveRampString.ck	Fourier's Model to synthesize a near-end pluck
KarpStrong1.ck		Basic Karplus Strong Plucked String Model
KarpStrong1MAUI.ck	GUI controller (MAC only, sorry).  Tcl/Tk version maybe later
KarpStrong2.ck		Enhanced (3pt FIR loop Filter) Plucked String
KarpStrong2MAUI.ck	GUI controller (MAC only, sorry).  Tcl/Tk version maybe later

The Cool Tcl/Tk GUI controlling all of the other
models (Clarinet, Flute, Trombone (and more available))
is available with the STK distribution.  Go download
that and then you can have all this stuff in c++.
The demo runs as it is, but the script Physical 
(or Physical.bat) gives you the interface used 
in the video lecture/demo.

Maybe I'll code up ChucK program to interpret the
same Tcl/Tk script used for this.  If there's enough
demand...

Enjoy!!!

END


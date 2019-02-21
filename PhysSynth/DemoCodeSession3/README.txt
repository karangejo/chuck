Simple Filter Examples from Session 3
Physics-Based Sound Synthesis, CCRMA/Kadenze
by Perry R. Cook, 2015
These should be Self-explanatory from use in 
lectures, and from comments within code.  A
couple of notes below about specific files.

OnePole.ck
OnePoleImpulse.ck
OnePoleImpulseScratch.ck
OneZero.ck
ThreeZero.ck
SevenZero.ck
OneZeroHighPassNative.ck
OneZeroHP.ck
OneZeroUGen.ck
FIRExample.ck
TwoPoleImpulse.ck

record.ck       NOTE:   if you run this (from Terminal/Command)
			in parallel with any code, it will capture
			the dac and write it out as a soundfile.
			Example:

>     chuck SevenZero.ck record.ck:temp:1.0

will capture the result of running SevenZero.ck and write
it out to a 1.0 second long soundfile named temp.wav

ResoLabChucK:     Coming soon (under separate cover), 
		    still making it work on multiple platforms

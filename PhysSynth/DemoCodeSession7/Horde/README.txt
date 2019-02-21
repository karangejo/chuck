Howdy!!  Welcome to Horde, a place to think about
particles, grains, flocks, crowds, gaggles, and 
other collections of sound-making things.

There are lots of sounds in the world that are made
up of lots of individual things making individual 
sounds, but they add up to make a sound with a different
name.  I don’t know what the sound of one hand clapping
might be, but two hands can make a clap.  Lots of clapping
hands makes up applause.

Type in:

chuck ApplauseWav10.ck

then stop that (control-c) and type:

chuck initApplauseWav100.ck

(control-c to stop it)

Doesn’t sound too real, but that’s just from one 
recorded Clap.wav sound.    Now try:

chuck ClapFilter.ck

(control-c to stop)

which makes one parametrically synthesized 
(noise => filter => dad) clapper.  Lots of
these makes up applause:

chuck initApplauseFilter20.ck

A single paramatrically synthesized bird tweet:

chuck Tweet.ck

This creates the sound of a flock:

chuck init.ck

which Machine.add()s Tweet.ck, and Flock.ck

These initXX.ck files set up our architecture for 
running multiple files, which we've used before for
PONG as well.  You'll need to be doing this for your
assignment submission, but yours must be called exactly
init.ck so we can grade it and the files it runs.

For many types of sounds, we can be more clever than creating
a unique instance for each member of a Horde.  That’s what PHISEM
(Physically Inspired Stochastic Event Modeling) is about.   Try:

chuck initPHISEMApplause.ck

and note that it accomplishes the same basic applause sound,
but much more efficiently.

PHISEM is bundled into a UGen with lots of presets.  All of those
are run through, with parameter changes, in this program:

chuck initShakersTest.ck

So you can build from scratch, or find something in Shakers
that’s close and modify it to fit your needs.

ENJOY!!!

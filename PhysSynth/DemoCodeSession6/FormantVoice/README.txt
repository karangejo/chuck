Yo!  This is a simple (but fairly complete) 
Formant Voice Model for speech synthesis.
by Perry R. Cook, developed over decades,
this particular ChucK version, Summer 2015

To test, type this in a Terminal Shell:

chuck init.ck

and hear the awesome, historical, singing!
(miniAudicle users see note at bottom of page).

The model/class is defined in FormantVoice.ck, and 
Daisy.ck makes one of it, and uses it to sing.  

Note that the model automatically does the smoothing
from one phoneme and pitch to the next, and automatically 
sets the gains of pitched/noise sources to do (roughly) the 
right things.

Now try 

chuck FormantVoice.ck TestAllPhonemes.ck

which says all of the phonemes the FormantVoice knows.

doing:
 
chuck FormantVoice.ck testAllCV.ck

tests all consonants in multiple Consonant/Vowel contexts.

There are quite a few things you can use to control the model,
including (but no limited to):

.pitch  .vibrato (vibrato is there for singing)

.voiced  .unVoiced  .consonant // these are source gains

now try:

chuck FormantVoice.ck SayChucK.ck

and 

chuck FormantVoice.ck Babble.ck

and note in the Babble.ck (and Daisy) code there’s also a 
“headSize” variable, which scales all of the formants up 
or down to give the impression of a larger or smaller head.
Default is 1.0.  1.2 is big head, 0.9 is smaller, etc.

As functions go, the biggie is the function:

.setPhoneme(string phonName); // where the possible phoneme names are:

    ["eee","ihh","ehh","aah","ahh","aww","ohh","uhh","uuu","ooo"] @=> string vowelNames[];
    ["rrr","lll","mmm","nnn","nng"] @=> string liquidNames[];
    ["bbb","ddd","ggg"] @=> string stopNames[];
    ["djj","vvv","zzz","tzz","zhh","gxx"] @=> string voicedFricNames[];
    ["fff","sss","thh","shh","cxh","xxx","hee","hah","hoo"] @=> string fricativeNames[];
    ["ppp","ttt","kkk","koo"] @=> string plosiveNames[];

All you need do is to make a speech sound is declare and connect
a FormantVoice to the dac, set a phoneme (and pitch if you like), 
and wait a bit:

FormantVoice fv => dac;
fv.setPhoneme(“ahh”);
second/2 => now;

But be sure to evaluate (chuck) FormantVoice.ck prior to
running your code.

miniAudicle users NOTE:  All you need to do is add FormantVoice.ck
once, then it’s declared, and all subsequent uses of it in your own
code will work fine.  If you want to edit FormantVoice.ck and make 
it better, add functions, etc., you’ll need to ClearVM before re-
adding FormantVoice.ck, or you’ll get a “Name already Defined” error.

END  Have fun with this vocal model!!!

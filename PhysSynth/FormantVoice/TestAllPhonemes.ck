FormantVoice fv => dac;
130 => fv.pitch;

for (int i; i < fv.vowels.cap(); i++)  {
    <<< fv.setPhoneme(fv.vowelNames[i]), fv.vowelNames[i] >>>;
    second / 2 => now;
}

for (int i; i < fv.liquids.cap(); i++)  {
    <<< fv.setPhoneme(fv.liquidNames[i]), fv.liquidNames[i] >>>;
    second / 2 => now;
}
for (int i; i < fv.stops.cap(); i++)  {
    <<< fv.setPhoneme(fv.stopNames[i]), fv.stopNames[i] >>>;
    second / 2 => now;
}

for (int i; i < fv.voicedFrics.cap(); i++)  {
    <<< fv.setPhoneme(fv.voicedFricNames[i]), fv.voicedFricNames[i] >>>;
    second / 2 => now;
}

for (int i; i < fv.frics.cap(); i++)  {
    <<< fv.setPhoneme(fv.fricativeNames[i]), fv.fricativeNames[i] >>>;
    second / 2 => now;
}
for (int i; i < fv.plosives.cap(); i++)  {
    <<< fv.setPhoneme(fv.plosiveNames[i]), fv.plosiveNames[i] >>>;
    second / 2 => now;
}




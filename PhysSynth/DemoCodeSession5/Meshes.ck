//  2 D Waveguide Mesh Demo
//    by Perry R. Cook, 2015

Mesh2D m => dac;

while (1)  {
    Math.random2(3,12) => m.x;
    Math.random2(3,12) => m.y;
    Math.random2f(0.995,0.9999) => m.decay;
    1 => m.noteOn;
    Math.random2f(200,800)::ms => now;
}


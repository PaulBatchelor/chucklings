//Engine eng;

//eng.clock::second => dur T;

(60 / 132.0):: second => dur T;

class Pattern {

    string name;
    float time;
}

function void pinit(Pattern pat, string name, float time) 
{
    name  => pat.name;
    time  => pat.time;
}

function void run_pat(Pattern pat[], int div[], int prob, string name, float gain) 
{

    LSamp ls => Rpt rpt => dac;
    ls.open(name);
    //eng.tempo => rpt.bpm;
    135 => rpt.bpm;
    0 => int inc;
    
    while(1)
    {
        if(Std.rand2(0,8) < prob) { 
            Std.rand2(1, 6) => rpt.rep;
            div[Std.rand2(0, (div.cap() - 1))] => rpt.div;
            rpt.trig();
        }
        Std.rand2f(0.3, 1) * gain=> ls.gain;
        ls.select(pat[inc].name);
        pat[inc].time * T => now;
        (inc + 1) % pat.cap() => inc;
    }

}

[3, 6, 16, 8] @=> int div[];

Pattern pat[3];

pinit(pat[0], "bass1", 1);
pinit(pat[1], "snare_1", 1);
pinit(pat[2], "snare_2", 0.5);

Pattern ride[4];
pinit(ride[0], "shake", 1);
pinit(ride[1], "cabasa", 1);
pinit(ride[2], "cowbell", 1);
pinit(ride[3], "conga", 0.5);

spork ~ 
run_pat(pat, div, 3, "LinnDrumLM1_96.smp", 0.8);
 
spork ~ 
run_pat(ride, div, 6, "LinnDrumLM1_96.smp", 0.3);

while(1) {
    1::second => now;
}
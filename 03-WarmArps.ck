//Engine eng;
//eng.clock::second => dur T;
//T - (now % T) => now;

(60.0 / 85)::second => dur T;

Gain revThrow => RevSC rev => dac;
0.2 => rev.mix;
0.98 => rev.feedback;

class SmoothSaw 
{
    //eng.clock::second => dur T;
    (60 / 85.0)::second => dur T;
    PulseOsc osc;
    Port p;
    Step freq;

    [60, 65, 67] @=> int notes[];
    4 => int rep;
    1 => float atk;
    8 => float notlen;
    0.004 => p.htime;
    2 => float notedur;
    0.125 => float beat;
    5 => float rest;
    800 => float cutoff;
  
    function void control() 
    {
        while(1::samp => now) {
            p.last() => osc.freq;
        }
    }

    function void arp() 
    {
        0 => int pos;
        while(1) {
            Std.mtof(notes[pos]) => freq.next;
            (pos + 1) % notes.cap() => pos;
            T * beat => now;
        }
    }    

    function void run()
    {
        osc => Moog lpf => Envelope env => dac;
        freq => p => blackhole;
        env => revThrow;
        cutoff => lpf.cutoff;
        0.4 => lpf.res;
        440 => freq.next;
        440 => osc.freq;
        0 => int pos;
        0.3 => env.gain;
        spork ~ control();
        spork ~ arp();
        while(1) {
            atk => env.time;
            env.keyOn();
            T => now;
            notedur => env.time;
            env.keyOff();
            T * rest => now;
        }
    }
}

SmoothSaw ss[4];

spork ~
ss[0].run();

8 * T => now;

[70, 67, 65, 64] @=> ss[1].notes;
2000 => ss[1].cutoff;
7 => ss[1].rest;
0.125 => ss[1].beat;
spork ~
ss[1].run();

8 * T => now;

[76, 74, 72, 77, 72] @=> ss[2].notes;
800 => ss[2].cutoff;
9 => ss[2].rest;
4 => ss[2].notedur;
0.25 => ss[2].beat;
spork ~
ss[2].run();

16 * T => now;

[72, 76, 70, 74] @=> ss[3].notes;
1000 => ss[3].cutoff;
36 => ss[3].rest;
16 => ss[3].notedur;
2 => ss[3].beat;
spork ~
ss[3].run();

while(1::second => now);
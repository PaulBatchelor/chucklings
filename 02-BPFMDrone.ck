//Engine eng;

Gain revSend => RevSC rev => dac;
0.3 => rev.gain;
1.0 => rev.mix;
class Drone 
{
    //eng.clock::second => dur T;
    
    (60.0 / 130.0) ::second => dur T;
    6 => float hold;
    6 => float rest;
    0 => int step;
    60 => float base;
    0 => float delay;
    function float getFreq() {
        return base * Math.pow(3, step/13.0) => float freq;
    }

    function void run()
    {
        FOsc f => Envelope e => dac;
        f => Gain g => revSend;
        0.2 => f.gain;
        0.2 => g.gain;
        1.1 => e.time;
        1.4 => f.index;
        while(1) {
            delay * T => now;
            getFreq() => f.freq;
            e.keyOn();
            hold * T  => now;
            e.keyOff();
            rest * T => now;
        }
    }
}

Drone drn[6];

12 => drn[0].rest;
6 => drn[0].hold;
0 => drn[0].step;
spork ~
drn[0].run();

6 => drn[1].rest;
6 => drn[1].hold;
13 => drn[1].step;
spork ~
drn[1].run();

8 => drn[2].rest;
6 => drn[2].hold;
19 => drn[2].step;
1 => drn[2].delay;
spork ~
drn[2].run();

8 => drn[3].rest;
6 => drn[3].hold;
24 => drn[3].step;
3 => drn[3].delay;
spork ~
drn[3].run();

24 => drn[4].rest;
6 => drn[4].hold;
23 => drn[4].step;
10 => drn[4].delay;
spork ~
drn[4].run();

8 => drn[5].rest;
8 => drn[5].hold;
26 => drn[5].step;
24 => drn[5].delay;
spork ~
drn[5].run();

while(1::second => now);
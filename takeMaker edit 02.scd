MIDIClient.init;
MIDIIn.connectAll;
~midiOut = MIDIOut.newByName("IAC Driver", "Bus 1");
~midiOut.noteOn(0, 81, 127);
~midiOut.noteOff(0, 81, 127);

(
var tempi = [ 32, 1024,512, 64 ];
~fade = ((1..127) ++ (126..0)) / 127;
(
Pdef(
    \Pat,
	Pseed(Pn(111, 1), Pbind(
    \type, \midi,
    \midiout, ~midiOut,
    \chan, 0,
    \midinote, 56, //55 - 96
	\bend, 0,
	\dur, 1,
	\tempo, Pseg(
		tempi/60,
		32,
		\lin,
		1
	),
	\amp, Pfunc{|ev|
			ev.use{
				~tempo.linlin(tempi.minItem/60, tempi.maxItem/60, 0, 1)
			};
	}
))).play(quant: 1);
CmdPeriod.doOnce {
    ~midiOut.allNotesOff(0);
};
);
)

(
~midiBend = Pbind(
\type,\midi,
\midicmd,\bend,
\midiout, ~midiOut,
\chan,0,
\dur, 1,
\val,Pwhite(0,16383)
)
)

// Stasis at top
// Curvature -1 to 1 where 0 is linear
// Pitchbend
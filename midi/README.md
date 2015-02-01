Midi
====

This project sends a midi 'Note On' command to channel 0.

I made myself a midi interface for the miniSpartan6+ using three
resistors and a transistor. midi.sch contains the circuit diagram.

It uses the 31.25 MHz clock which is divided down to 31.25 KHz, which
is the speed the midi protocol works at. The midi serial protocol is
pretty simple - it's a start bit (0), followed by 8 bits (LSB first),
followed by a stop bit (1). Logical zeros are represented by a current
flowing in the midi circuit, while ones are represented by a lack of
current, hence the "not"s in the vhdl.


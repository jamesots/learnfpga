Componentized the midi sending component.

The clock speed must be 31.25Hz.


When load goes high, data_in is loaded and starts being transmitted on midi_out
on the next clock cycle. Load must then go low, otherwise it'll go wrong.

Ready goes high while the last bit of data is being transmitted (2 bits before the
stop bit finishes being transmitted). This gives you time to set load to high
on the next clock cycle, so that the midi component can start transmitting the
next byte as soon as the stop bit has been transmitted.


Oscilloscope
============

This reads values from the ADC and sends them to the PC, as fast as it will read them.

The first byte sent starts with a 0, followed by 6 bits of data, followed by a parity bit.
The second byte is similar, except it starts with a 1.

Sending data to the PC seems quite unreliable. I'm not sure if it's timing on the FPGA end
or the libftdi drivers on the PC end, but there seem to be quite a few bytes which are
doubled up, missed, or wrong.

There's also a java programme which shows the data. It's not very good, but it just needed
to be good enough to kind of see what a signal looked a bit like.


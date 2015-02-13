miniSpartan6+ Projects
======================

I have just got a miniSpartan6+ FPGA development board, and I'm learning to use it.
This is going to be where I put the files I play with. There's some C stuff, which
uses standard make files, and the VHDL stuff, which uses hdlmake to generate makefiles,
and also relies on Xilinx ISE being installed. I'm doing all this stuff in Linux.

* echotest: This was my first project (after the blinking LEDs one everyone does),
which echoes back everything you type via the FTDI chip.
* analogue: My second project, which reads a voltage on an analogue input and displays the
value on the LEDs as a bargraph.
* midi: My third project. (Actually, my fourth, but the third isn't working yet). Sends
midi commands. Well, one midi command, repeatedly.
* analogue2: 4th project. An improvement on the original analogue project, using
an ADC component and shift registers.
* fifo: An attempt at a dual clock fifo.

Notes
-----

Programmes I'm using:
* Xilinx ISE 14.7. I found instructions somewhere for installing in on Ubuntu. I can't remember
where as it was a few months ago now.
* boot, from freerangefactory.org. I don't remember how I installed it, but it's quite useful
for running a testbench in and seeing waveforms/timing diagrams/whatever you're supposed to call
them.
* hdlmake, so that I can build things in a nice repeatable way.
* xc3sprog, to load the bit files into the FPGA

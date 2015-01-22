This is a simple project which reads everything from the FTDI chip and echoes it back.

You'll need to programme the EEPROM in the FTDI chip so that channel B is configured
as an FT245 FIFO. I used the Windows FT_PROG programme, which was a pain because I had
to boot into Windows, but at least it's a one time job.

Use my termfpga programme to test this.

I also connected up the DIP switches to test them. SW1 has to be switched on for 
anything to get echoed. The FTDI will buffer stuff while SW1 is off.



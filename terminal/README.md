termfpga
========

This is a simple terminal programme which sends everything you type to the FTDI chip on the 
miniSpartan6+, and echos everything which it receives. This means you'll probably end up
with everything appearing twice, but that proves it's working!

Press END to quit the programme. Press INS to do a carriage return, because ncurses turns 
Ctrl-M and Ctrl-J into linefeeds.


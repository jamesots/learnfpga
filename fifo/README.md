This is my attempt at a dual clocked fifo.

You can write to to fifo from one clock domain and read from it from a different unrelated clock. Hopefully.

* wr_clk is the clock for the write clock domain.
* wr_data is the data to be written.
* wr_full is high when the fifo is full.
* when wr is high and wr_full is low, wr_data is clocked into the fifo on wr_clk's rising edge.

* rd_clk is the clock for the read clock domain.
* rd_data is the data which has been read from the fifo.
* rd_empty is high when the fifo is empty.
* when rd is high and rd_empty is low, data from the fifo is clocked onto rd_data on rd_clk's rising edge.

The wr_full and rd_empty signals go high on the falling clock edge after the fifo became full or empty.
When the fifo stops becoming full or empty the signals go low a few clock cycles later.

When the head and tail counters are encoded as gray codes, one more bit is used which holds the loop flag.
In order to compare the gray codes, the MSB is taken off as the looped flag. If it is high, the next-MSB is
inverted, which gives a gray code which can be compared with a non-looped code.

Each comparator contains a bus synchronizer which uses two flip-flips per signal to guard against metastability.

There are two comparators, one which synchronizes the tail counter into the write domain, and one which
synchronizes the head counter into the tail domain. The looped and equal flags are then compared to decide whether
the fifo is full or empty. The wr_full signal goes high half a clock cycle after the fifo becomes full so that
you don't try to write to a full fifo, while it takes a couple of clock cycles to go low after there is space again
in the fifo.

I don't guarantee this code is correct. Actually, I can almost guarantee it's not correct! I've spent a couple
of weeks learning about all this clock domain stuff, and I'm a complete novice at VHDL, so I'd be surprised
if this is completely right.


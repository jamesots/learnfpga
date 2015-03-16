package com.jamesots.libftdi;

import javax.swing.*;
import java.nio.ByteBuffer;
import java.util.List;

public class Oscilloscope {
    void run() {
        final OscilloscopeForm form = new OscilloscopeForm();
        form.run();

        final SwingWorker<Void, Long> worker = new SwingWorker<Void, Long>() {
            @Override
            protected Void doInBackground() throws Exception {
                try (Ftdi ftdi = new Ftdi()) {
                    try {
                        ftdi.setInterface(Ftdi.Interface.B);
                        ftdi.usbOpen(0x0403, 0x6010);
                        ftdi.usbReset();
                        ftdi.purgeBuffers();
                        ftdi.setBitmode(0x0F, Ftdi.Bitmode.RESET);
                        System.out.println("Connected");

                        final ByteBuffer byteBuffer = ByteBuffer.allocateDirect(10);
                        long num = 0;
                        boolean firstGood = false;
                        int divider = 0;
                        while (!isCancelled()) {
                            try {
                                int size = ftdi.readData(byteBuffer, 1);
                                if (size > 0) {
                                    final byte b = byteBuffer.get(0);
                                    final int bb = b & 0xFF;
                                    if (bb < 0b10000000) {
                                        num = ((bb >> 1) & (0b111111)) << 6;

                                        int expectedParity = bb & 1;
                                        int actualParity =
                                                ((bb >> 1) & 1)
                                                ^ ((bb >> 2) & 1)
                                                ^ ((bb >> 3) & 1)
                                                ^ ((bb >> 4) & 1)
                                                ^ ((bb >> 5) & 1)
                                                ^ ((bb >> 6) & 1);
                                        firstGood = expectedParity == actualParity;
                                    } else {
                                        num = num + ((bb >> 1) & (0b111111));

                                        int expectedParity = bb & 1;
                                        int actualParity =
                                                ((bb >> 1) & 1)
                                                ^ ((bb >> 2) & 1)
                                                ^ ((bb >> 3) & 1)
                                                ^ ((bb >> 4) & 1)
                                                ^ ((bb >> 5) & 1)
                                                ^ ((bb >> 6) & 1);

                                        if (firstGood && (expectedParity == actualParity)) {
                                            divider++;
                                            if (divider > 100) {
                                                divider = 0;
                                                publish(num);
                                            }
                                        }
                                        firstGood = false;
                                    }
                                }
                            } catch (UsbReadError e) {
                                System.out.println(e);
                                ftdi.reinit();
                                ftdi.setInterface(Ftdi.Interface.B);
                                ftdi.usbOpen(0x0403, 0x6010);
                                ftdi.usbReset();
                                ftdi.purgeBuffers();
                                ftdi.setBitmode(0x0F, Ftdi.Bitmode.RESET);
                            }
                        }
                    } catch (FtdiException e) {
                        System.out.println(e);
                    }
                }

                return null;
            }

            long[] longs = new long[500];
            int next = 0;

            @Override
            protected void process(List<Long> chunks) {
                for (int i = 0; i < chunks.size(); i++) {
                    longs[next++] = chunks.get(i);
                    if (next == 500) {
                        form.getOscilloscopeWidget().setValues(longs);
                        form.getOscilloscopeWidget().repaint();
                        next = 0;
                    }
                }

            }
        };
        worker.run();
    }

    public static void main(String[] args) {
        final Oscilloscope oscilloscope = new Oscilloscope();
        oscilloscope.run();
    }
}


import com.jamesots.libftdi.Ftdi;
import com.jamesots.libftdi.LibFtdi;
import com.jamesots.libftdi.UsbReadError;

import java.nio.ByteBuffer;

public class Test {
    public static void main(String[] args) {
        try (Ftdi ftdi = new Ftdi()) {

            ftdi.setInterface(Ftdi.Interface.B);
            ftdi.usbOpen(0x0403, 0x6010);

            System.out.println("Opened FT245");

            ftdi.usbReset();
            ftdi.purgeBuffers();
            ftdi.setBitmode(0x0F, Ftdi.Bitmode.RESET);

            int i = 0;
            final ByteBuffer byteBuffer = ByteBuffer.allocateDirect(10);
            while (true) {
                try {
                    int size = ftdi.readData(byteBuffer, 1);
                    if (size > 0) {
                        i++;
                        char c = (char) byteBuffer.get(0);
                        //                System.out.print(c);
                        //                if (c == '#') {
                        //                    System.out.println();
                        //                } else
                        if (c < 32 || c > 126) {
                            System.out.print("<" + (byte) c + ">");
                        }
                        //                if (i > 1000000) {
                        //                    i = 0;
                        //                    System.out.print(".");
                        //                }
                    }
                } catch (UsbReadError e) {
                    System.out.println(e);
                }
            }


            //        ftdi.deinit(ctx);
            //        System.out.println("Bye");
        }
    }

    public static void oldmain(String[] args) {
        final LibFtdi ftdi = new LibFtdi();
        long ctx = ftdi.init();

        if (ftdi.setInterface(ctx, 2) < 0) {
            throw new RuntimeException("Can't set interface");
        }

        if (ftdi.usbOpen(ctx, 0x403, 0x6010) < 0) {
            throw new RuntimeException("Can't open device");
        }

        System.out.println("Opened FT245");

        if (ftdi.usbReset(ctx) < 0) {
            throw new RuntimeException("Can't reset device");
        }

        ftdi.purgeBuffers(ctx);

        if (ftdi.setBitMode(ctx, 0x0F, 0x00) < 0) {
            throw new RuntimeException("Can't disable bitbang mode");
        }

        int i = 0;
        final ByteBuffer byteBuffer = ByteBuffer.allocateDirect(10);
        while (true) {
            int size = ftdi.readData(ctx, byteBuffer, 1);
            if (size > 0) {
                i++;
                char c = (char) byteBuffer.get(0);
//                System.out.print(c);
//                if (c == '#') {
//                    System.out.println();
//                } else
            if (c < 32 || c > 126) {
                    System.out.print("<" + (byte) c + ">");
                }
//                if (i > 1000000) {
//                    i = 0;
//                    System.out.print(".");
//                }
            }
        }


//        ftdi.deinit(ctx);
//        System.out.println("Bye");
    }
}

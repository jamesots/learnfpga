package com.jamesots.libftdi;

import java.nio.ByteBuffer;

public class LibFtdi {
    static {
        System.loadLibrary("LibFtdi");
    }

    public static native long init();

    public static native int setInterface(long ctx, int iface);

    public static native int usbOpen(long ctx, int vendor, int product);

    public static native int usbReset(long ctx);

    public static native int purgeBuffers(long ctx);

    public static native int setBitMode(long ctx, int thing, int mode);

    public static native int readData(long ctx, ByteBuffer buffer, int size);

    public static native int writeData(long ctx, ByteBuffer buffer, int size);

    public static native void deinit(long ctx);
}

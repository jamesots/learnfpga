package com.jamesots.libftdi;

public class UsbWriteError extends Exception {
    public final int code;

    public UsbWriteError(int code) {
        super("Error " + code + " from libusb_bulk_write()");
        this.code = code;
    }
}

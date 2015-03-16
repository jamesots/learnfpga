package com.jamesots.libftdi;

public class UsbReadError extends Exception {
    public final int code;

    public UsbReadError(int code) {
        super("Error " + code + " from libusb_bulk_transfer()");
        this.code = code;
    }
}

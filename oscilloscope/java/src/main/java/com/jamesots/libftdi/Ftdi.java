package com.jamesots.libftdi;

import java.nio.ByteBuffer;

public class Ftdi implements AutoCloseable {
    private Long ctx;

    public enum Interface {
        ANY,
        A,
        B,
        C,
        D
    }

    public enum Bitmode {
        RESET(0x00),
        BITBANG(0x01),
        MPSSE(0x02),
        SYNCBB(0x04),
        MCU(0x08),
        OPTO(0x10),
        CBUS(0x20),
        SYNCFF(0x40);

        final int value;

        Bitmode(int value) {
            this.value = value;
        }
    }

    public Ftdi() {
        ctx = LibFtdi.init();
    }

    @Override
    public void close() {
        LibFtdi.deinit(ctx);
        ctx = null;
    }

    public void reinit() {
        LibFtdi.deinit(ctx);
        ctx = LibFtdi.init();
    }

    public void setInterface(Interface iface) {
        assertOpen();

        final int result = LibFtdi.setInterface(ctx, iface.ordinal());
        if (result == 0) {
            return;
        }
        switch (result) {
            case -1:
                throw new FtdiException(result, "Unknown interface");
            case -2:
                throw new FtdiException(result, "USB device unavailable");
            case -3:
                throw new FtdiException(result, "Device already open, interface can't be set in that state");
            default:
                throw new FtdiException(result, "Unknown error");
        }
    }

    public void usbOpen(int vendor, int product) {
        assertOpen();

        final int result = LibFtdi.usbOpen(ctx, vendor, product);
        if (result == 0) {
            return;
        }
        switch (result) {
            case -3:
                throw new FtdiException(result, "USB device not found");
            case -4:
                throw new FtdiException(result, "Unable to open device");
            case -5:
                throw new FtdiException(result, "Unable to claim device");
            case -6:
                throw new FtdiException(result, "Reset failed");
            case -7:
                throw new FtdiException(result, "Set baudrate failed");
            case -8:
                throw new FtdiException(result, "Get product description failed");
            case -9:
                throw new FtdiException(result, "Get serial number failed");
            case -12:
                throw new FtdiException(result, "libusb_get_device_list() failed");
            case -13:
                throw new FtdiException(result, "libusb_get_device_descriptor() failed");
            default:
                throw new FtdiException(result, "Unknown error");
        }
    }

    public void usbReset() {
        assertOpen();

        final int result = LibFtdi.usbReset(ctx);
        if (result == 0) {
            return;
        }
        switch (result) {
            case -1:
                throw new FtdiException(result, "FTDI reset failed");
            case -2:
                throw new FtdiException(result, "USB device unavailable");
            default:
                throw new FtdiException(result, "Unknown error");
        }
    }

    public void purgeBuffers() {
        assertOpen();

        final int result = LibFtdi.purgeBuffers(ctx);
        if (result == 0) {
            return;
        }
        switch (result) {
            case -1:
                throw new FtdiException(result, "Read buffer purge failed");
            case -2:
                throw new FtdiException(result, "Write buffer purge failed");
            case -3:
                throw new FtdiException(result, "USB device unavailable");
            default:
                throw new FtdiException(result, "Unknown error");
        }
    }

    public void setBitmode(int bitmask, Bitmode mode) {
        assertOpen();

        final int result = LibFtdi.setBitMode(ctx, bitmask, mode.value);
        if (result == 0) {
            return;
        }
        switch (result) {
            case -1:
                throw new FtdiException(result, "Can't enable bitbang mode");
            case -2:
                throw new FtdiException(result, "USB device unavailable");
            default:
                throw new FtdiException(result, "Unknown error");
        }
    }

    public int readData(ByteBuffer buffer, int size) throws UsbReadError {
        assertOpen();

        final int result = LibFtdi.readData(ctx, buffer, size);
        if (result >= 0) {
            return result;
        }
        switch (result) {
            case -666:
                throw new FtdiException(result, "USB device unavailable");
            default:
                throw new UsbReadError(result);
        }
    }

    public int writeData(ByteBuffer buffer, int size) throws UsbWriteError {
        assertOpen();

        final int result = LibFtdi.writeData(ctx, buffer, size);
        if (result > 0) {
            return result;
        }
        switch (result) {
            case -666:
                throw new FtdiException(result, "USB device unavailable");
            default:
                throw new UsbWriteError(result);
        }
    }

    private void assertOpen() {
        if (ctx == null) {
            throw new RuntimeException("Trying to operate on a closed connection");
        }
    }
}

package com.jamesots.libftdi;

public class FtdiException extends RuntimeException {
    public final int code;

    public FtdiException(int code, String message) {
        super(message);
        this.code = code;
    }
}

#include <ftdi.h>
#include "LibFtdi.h"

JNIEXPORT long JNICALL Java_com_jamesots_libftdi_LibFtdi_init
  (JNIEnv *env, jclass cls) {
    struct ftdi_context *ctx = malloc(sizeof(struct ftdi_context));
    ftdi_init(ctx);
    return (long) ctx;
}

JNIEXPORT jint JNICALL Java_com_jamesots_libftdi_LibFtdi_setInterface
  (JNIEnv *env, jclass cls, jlong ctx, jint aOrB) {
    return ftdi_set_interface((struct ftdi_context*)ctx, aOrB);
}

JNIEXPORT jint JNICALL Java_com_jamesots_libftdi_LibFtdi_usbOpen
  (JNIEnv *env, jclass cls, jlong ctx, jint vendor, jint product) {
    return ftdi_usb_open((struct ftdi_context*)ctx, vendor, product);
}

JNIEXPORT jint JNICALL Java_com_jamesots_libftdi_LibFtdi_usbReset
  (JNIEnv *env, jclass cls, jlong ctx) {
    return ftdi_usb_reset((struct ftdi_context*)ctx);
}

JNIEXPORT jint JNICALL Java_com_jamesots_libftdi_LibFtdi_purgeBuffers
  (JNIEnv *env, jclass cls, jlong ctx) {
      return ftdi_usb_purge_buffers((struct ftdi_context*)ctx);
}

JNIEXPORT jint JNICALL Java_com_jamesots_libftdi_LibFtdi_setBitMode
  (JNIEnv *env, jclass cls, jlong ctx, jint bitmask, jint mode) {
    return ftdi_set_bitmode((struct ftdi_context*)ctx, bitmask, mode);
}

JNIEXPORT jint JNICALL Java_com_jamesots_libftdi_LibFtdi_readData
  (JNIEnv *env, jclass cls, jlong ctx, jobject buffer, jint size) {
    void* buf = (*env)->GetDirectBufferAddress(env, buffer);
    return ftdi_read_data((struct ftdi_context*)ctx, buf, size);
}

JNIEXPORT jint JNICALL Java_com_jamesots_libftdi_LibFtdi_writeData
  (JNIEnv *env, jclass cls, jlong ctx, jobject buffer, jint size) {
    void* buf = (*env)->GetDirectBufferAddress(env, buffer);
    return ftdi_write_data((struct ftdi_context*)ctx, buf, size);
}

JNIEXPORT void JNICALL Java_com_jamesots_libftdi_LibFtdi_deinit
  (JNIEnv *env, jclass cls, jlong ctx) {
    free((struct ftdi_context*)ctx);
}

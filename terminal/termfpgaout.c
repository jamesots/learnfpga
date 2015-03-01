#include <stdio.h>
#include <ftdi.h>

int main()
{
    unsigned char c = 0;
    struct ftdi_context ftdic;

    ftdi_init(&ftdic);
    
    int res;
    if (ftdi_set_interface(&ftdic, INTERFACE_B) < 0) {
        puts("Can't choose device");
        return 1;
    }
    
    if (ftdi_usb_open(&ftdic, 0x0403, 0x6010) < 0) {
        puts("Can't open device");
        return 1;
    }
    puts("Opened FT245");
    
    if (res = ftdi_usb_reset(&ftdic) < 0) {
        printf("Can't reset interface %d\n", res);
        return 1;
    }

    ftdi_usb_purge_buffers(&ftdic);

    if (ftdi_set_bitmode(&ftdic, 0x0F, BITMODE_RESET) < 0) {
        puts("Can't disable bitbang mode");
        return 1;
    }
    
    printf("\nType to send to Z80:\n");
    printf("Press END to end:\n");
    unsigned char buf[80];
    
    int finished = 0;
    int i;
    while (!finished) {
            i = ftdi_read_data(&ftdic, &buf[0], 1);
            if (i > 0) {
		if (buf[0] < 32) {
                    printf("<%d>", buf[0]);
		} else if (buf[0] > 126) {
		    printf("<%d>", buf[0]);
		} else {
                    printf("%c", buf[0]);
                }
if (buf[0] == '#') {
printf("\n");
}
            }
    }
}


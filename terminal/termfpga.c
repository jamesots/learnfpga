#include <stdio.h>
#include <ftdi.h>
#include <ncurses.h>

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
    initscr();
    clear();
    raw();
    noecho();
    nodelay(stdscr, TRUE);
    keypad(stdscr, TRUE);
    
    printw("\nType to send to Z80:\n");
    printw("Press END to end:\n");
    refresh();
    unsigned char buf[80];
    
    int finished = 0;
    int i;
    while (!finished) {
        int c = getch();
        if (c == ERR) {
            i = ftdi_read_data(&ftdic, &buf[0], 1);
            if (i > 0) {
                printw("%c", buf[0]);
            }
            continue;
        }
        if (c == KEY_END) {
            // quit the app with the END key
            endwin();
            return 0;
        }
        if (c == KEY_IC) {
            // ncurses makes ^M and ^J produce LF,
            // so map INSERT to CR
            c = '\r';
        }
        
        buf[0] = c;
        
        do {
            i = ftdi_write_data(&ftdic, &buf[0], 1);
        } while (i < 0);
        
        if (c == '\r') {
            printw("\n");
        }
        printw("%c", c);
        refresh();
    }
    
    endwin();
}


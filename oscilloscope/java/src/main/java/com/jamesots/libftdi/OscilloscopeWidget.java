package com.jamesots.libftdi;

import javax.swing.*;
import java.awt.*;

public class OscilloscopeWidget extends JComponent {
    long[] values = null;

    public OscilloscopeWidget() {
        super();
    }

    @Override
    public void paint(Graphics g) {
        if (values == null) {
            return;
        }
        final Dimension size = getSize();
        g.setColor(Color.BLACK);
        g.setPaintMode();
        g.fillRect(0, 0, size.width, size.height);
        g.setColor(Color.WHITE);
        g.drawLine(100, 0, 100, 500);
        g.drawLine(0, 400, 600, 400);
        g.drawLine(90, (400 / 5), 100, (400 / 5));
        g.drawLine(90, 2 * (400/5), 100, 2 * (400/5));
        g.drawLine(90, 3 * (400/5), 100, 3 * (400/5));
        g.drawLine(90, 4 * (400/5), 100, 4 * (400/5));

        g.setColor(Color.GREEN);
        for (int i = 0; i < 499; i++) {
            g.drawLine(100+i, 400 - (int) (((double) values[i]) / 0xFFF * 400),
                    100+i+1, 400 - (int) (((double) values[i+1]) / 0xFFF * 400));
        }
    }

    public void setValues(long[] values) {
        this.values = values;
    }

    @Override
    public Dimension getPreferredSize() {
        return new Dimension(600, 500);
    }
}

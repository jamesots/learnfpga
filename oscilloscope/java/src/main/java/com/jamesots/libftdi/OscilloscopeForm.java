package com.jamesots.libftdi;

import javax.swing.*;

public class OscilloscopeForm {
    private JPanel panel;
    private OscilloscopeWidget oscilloscopeWidget;

    public OscilloscopeWidget getOscilloscopeWidget() {
        return oscilloscopeWidget;
    }

    public void run() {
        JFrame frame = new JFrame("OscilloscopeForm");
        frame.setContentPane(panel);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);
    }
}

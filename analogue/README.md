This project reads from AIN7 and displays the value on the LEDs, in bargraph form.

You can change which port it reads from by changing the value of ad_port. 

In theory I don't need to take CS high and low again, but I can't seem 
to get the frame timing right without it. And even with it, sometimes the 
port it reads from gets shifted. I need to do something about that.

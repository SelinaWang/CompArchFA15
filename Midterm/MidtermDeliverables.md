#Computer Architecture Midterm#

##Specification Document#
###Inputs and Outputs###
This bike light takes one input from a single button and returns one output to a single LED. The bike light cycles through its four operational modes by pressing the button (details are described in the following section).

###Operational Modes###
This bike light has four modes: Off, On, Blinking, and Dim (On at approximately 50% brightness):

![four modes: Off, On, Blinking, and Dim](https://github.com/SelinaWang/CompArchFA15/blob/master/Midterm/Images/waveforms.png)

The modes are cycled through in the following fashion:

![Cycling through the four modes](https://github.com/SelinaWang/CompArchFA15/blob/master/Midterm/Images/FSM.PNG)

The LED flashes at a frequency of 3Hz in blinking mode.

##Block Diagram##
![Block Diagram](https://github.com/SelinaWang/CompArchFA15/blob/master/Midterm/Images/BlockDiagram.PNG)
clk is a 32,768Hz (2^15) square wave to drive the clocked logic in the rest of the system. Dimming: http://www.digikey.com/en/articles/techzone/2010/apr/how-to-dim-an-led

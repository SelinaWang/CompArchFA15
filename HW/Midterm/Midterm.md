#Computer Architecture Midterm#

##Specification Document#
###Inputs and Outputs###
This bike light takes one input from a single button and returns one output to a single LED. The bike light cycles through its four operational modes by pressing the button (details are described in the following section).

###Operational Modes###
This bike light has four modes: Off, On, Blinking, and Dim (On at approximately 50% brightness):

![four modes: Off, On, Blinking, and Dim](https://github.com/SelinaWang/CompArchFA15/blob/master/HW/Midterm/waveforms.png)

The modes are cycled through in the following fashion:

![Cycling through the four modes](https://github.com/SelinaWang/CompArchFA15/blob/master/HW/Midterm/FSM.PNG)

The LED flashes at a frequency of 3Hz in blinking mode.


clk is a 32,768Hz (2^15) square wave to drive the clocked logic in the rest of the system. So 5 flip flops should be used for an Up Counter that gives out a 3Hz frequency for the blinking mode.

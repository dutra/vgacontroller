VGA Controller
==============

This repository contains a very simple Bluespec implementation of a VGA controller.

`mkVGA.bsv` file contains the module responsible for the VGA timing implementation. We are using 800x600@60fps, with a 40 MHz frame clock, for this instance. The module displays a simple RGB flag on the monitor.

`mkLed.bsv` file contains a simple module to control the LEDs in an Terasic SocKit board. Change the number of bits to fit your board.

An useful table with VGA Timings can be found at http://tinyvga.com/vga-timing
A very good description of VGA timing can be found here http://faculty.lasierra.edu/~ehwang/public/mypublications/VGA%20Monitor%20Controller.pdf and here  http://www.es.isy.liu.se/courses/TSTE12/download/TSTE12_Lab2_120613.pdf
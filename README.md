In this repository, it is presented the whole design of  RISC processor. Therefore, the design of every functional block (arithmetic and control units among others) is written in Verilog and the verfication of every single block is provided. Although this project has an intermediate to advanced complexity, the main goal of making this repository public is to attract hardware designers to work on project that really matter, instead of spending time and computing resources in merely simulations divorced from reality.

We are periodically documenting every file in order to provide a better understanding about the functionality of each block. In case some questions arise during the exploration of the source code, please do no hesitate to contact us.


# Processor-Design

This directory presents the design of a ZDMI Microcontroller Core (ZMC), which is designed to be integrated into a System on Chip (SoC) and 
it is oriented for calibration applications. The main characteristics of the ZMC are:

1. RISC architecture: most instructions are executed in only one clock cycle. Additionally, it supports 16 and 32-bits instruction formats.
2. Built-in PRAM: integrated program memory.
3. Register file with segmentation of up to 128 data words.
4. High speed bus interface for peripheral device and external memory attachment.
5. Continuous execution of the program memory.
6. High variety of logic and shift instructions.
7. Synchronization and interrupt mechanism.

Inside each module will be provided a description of its functionality. The Wishbone specification will not be presented due to the copyrights owned by Cadence, platform in which this project was developed. 

DISCLAIMER: I do not own or possess any right of the ZMDI Microcontroller specification. I refrain from making public the contents of the technical file that was provided by the tutors and supervisors of this course. This work has been developed only for academic 
purposes for the course of Processor Design at the VLSI chair of the Technische Universität Dresden. I do give credit to Marco Stolba Marco.Stolba@tu-dresden.de for the development of some modules presented in this directory. 

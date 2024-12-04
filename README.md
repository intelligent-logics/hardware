inside the "deprecated" folder is the following folders:

+---deprecated
|
|
+---fpga_nes_bennett
|	An open source FPGA NES that we tried to use at one point.
|	https://github.com/brianbennett/fpga_nes
|
+---fpganes
|	A fork of the "nes_strigeus" core.
|	We could not find the original author of the repo.
|
+---fpganes_release
|	A FPGA NES made by 4 students at the University of Wisconsin-Madison
|	for a senior project
|	https://github.com/jtgebert/fpganes_release
|
+---ilnes
|	our own attempt at making the core from scratch as a last ditch effort
|	before pivoting back to the mister core
|
+---instructionlatch
|	A very simple latch.
|
+---mister_NES_core_nosavestates
|	A very old MISTer core that has no ability to save your game state.
|	We used this as an attempt to build our own core.
|	https://github.com/MiSTer-devel/NES_MiSTer
|
+---monitortest
|	Not sure what this is or how it got in here. Leaving it here because it could be useful.
|
+--naked_core
|	The "mister_NES_core_nosavestates" core but stripped down to the bare naked CPU, APU, and PPU
|
+---nes_strigeus
|	The original core that started the FPGA NES community thats still going today. 
|	We tried to use this core but it did not work
|	https://github.com/strigeus/fpganes
|
+---Russian
|	(May or may not be okay to use because of the current political situation)
|	A core we tried to build ourselves based off of extensive research done by a Russian electronics engineer.
|	The CPU was pulled from https://github.com/andkorzh/BREAKS6502
|	The APU was pulled from https://github.com/andkorzh/RP2A03-7-
|	The PPU was pulled from https://github.com/andkorzh/RP2C02-7-
|	All 3 were made by the same brilliant guy
|
+---spi
|	A SPI slave module we needed at one point.
|	Credit for the original Verilog code is in the "SPI.v" file

inside the "working" folder is the following folder(s):

+---working
|
|
+---mister_nes
|	the most up to date version of the NES MISTer core. With our own simple modifications
|	https://github.com/MiSTer-devel/NES_MiSTer

inside the "help" folder is some Verilog code that may be useful as a refresher for those who are new or haven't touched it in awhile.

TO BUILD THE CURRENT WORKING CORE:
1. Navigate to working/mister_nes
2. Open NES.qpf (Quartus project file, Quartus must be installed)
3. Compile Core in Quartus (Ctrl L, OR click forward arrow with no checkmarks on the top navigation menu)
4. Program the device (Must connect USB Blaster to laptop and FPGA). 

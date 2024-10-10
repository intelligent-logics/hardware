The "mister_NES_core_savestates" folder is the most recent mister nes core.
https://github.com/MiSTer-devel/NES_MiSTer

The "fpganes_UWM" contains a quartus port of an NES core made for a senior project at the university of washington madison.
https://github.com/jtgebert/fpganes_release

The "naked_core" folder is the mister core (without savestates) stripped down to the bare naked cpu, apu, ppu, and multi-cart mapper. it contains no io, no sound, no video, nothing.


inside the "working" folder is the following folders:

The "nes_strigeus" folder is the current iteration of the core. It uses UART to load ROMs into the core. 
https://github.com/strigeus/fpganes/tree/master


inside the "help" folder is the following folders:


TO BUILD THE CURRENT CORE:
1. Navigate to working/nes_strigeus
2. Open nes_stigeus.qpf (Quartus project file, Quartus must be installed)
3. Compile Core in Quartus (Ctrl L, OR click forward arrow with no checkmarks on the top navigation menu)
4. Program the device (Must connect USB Blaster to laptop and FPGA). 

verilog_examples
Work: As of this repos last commit for the beta build, we did the following:
Added NEW CORE
Added GPIO for the Raspberry Pi
Added software tests for UART, can be found in software repo (https://github.com/intelligent-logics/software)

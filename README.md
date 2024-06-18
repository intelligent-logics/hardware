inside the "deprecated" folder is the following folders:

fpganes

MIST_NES_CORE

mister_NES_core_nosavestates

mister_NES_core_savestates

naked_core


The "fpganes" folder contains a quartus port of the fpganes project by jtgebert.
https://github.com/jtgebert/fpganes-1

The "MIST_NES_core" folder contains the core for the MIST NES core. This core is what the MISTER is based on.
https://github.com/mist-devel/nes

The "mister_NES_core_nosavestates" folder is the mister NES core but without the ability to save your game. Which is what was requested from us.
https://github.com/MiSTer-devel/NES_MiSTer/tree/5125c1bfffa421f27f415793016ce9c1aa5dd836

The "mister_NES_core_savestates" folder is the most recent mister nes core.
https://github.com/MiSTer-devel/NES_MiSTer

The "naked_core" folder is the mister core (without savestates) stripped down to the bare naked cpu, apu, ppu, and multi-cart mapper. it contains no io, no sound, no video, nothing.


inside the "working" folder is the following folders:

fpganes_UWM

The "fpganes_UWM" contains a quartus port of an NES core made for a senior project at the university of washington madison.
https://github.com/jtgebert/fpganes_release


inside the "help" folder is the following folders:

verilog_examples


Work: As of this repos last commit, we did the following:
added verilog tutorial files
added new nes core: "fpganes_UWM"
added HDMI transmitter to "fpganes_UWM"
added VGA support to "fpganes_UWM"


#============================================================
# ilscript
# Author(s): Steven Miller
# Date created: October 30 2024
# Purpose: makes it so pins are automatically assigned for us when we compile
# Notes:
# $October 30 2024, Steven: initial creation
# $OCtober 31 2024, Steven: added clock output for oscilloscope
#============================================================

#cpu instruction output
set_location_assignment PIN_AH26 -to cpu_debug_instruction[7]
set_location_assignment PIN_AF25 -to cpu_debug_instruction[6]
set_location_assignment PIN_AF23 -to cpu_debug_instruction[5]
set_location_assignment PIN_AH22 -to cpu_debug_instruction[4]
set_location_assignment PIN_AG21 -to cpu_debug_instruction[3]
set_location_assignment PIN_AA20 -to cpu_debug_instruction[2]
set_location_assignment PIN_AE22 -to cpu_debug_instruction[1]
set_location_assignment PIN_AF21 -to cpu_debug_instruction[0]
set_location_assignment PIN_AC24 -to system_clock
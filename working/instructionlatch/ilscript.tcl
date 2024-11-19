#============================================================
# ilscript
# Author(s): Steven Miller
# Date created: October 30 2024
# Purpose: makes it so pins are automatically assigned for us when we compile
# Notes:
# $October 30 2024, Steven: initial creation
# $OCtober 31 2024, Steven: added clock output for oscilloscope
# $November 15 2024,Steven: changed for instruction latch design
#============================================================

#cpu instruction output
set_location_assignment PIN_AH26 -to o_instructionlatch_Q0[7]
set_location_assignment PIN_AF25 -to o_instructionlatch_Q0[6]
set_location_assignment PIN_AF23 -to o_instructionlatch_Q0[5]
set_location_assignment PIN_AH22 -to o_instructionlatch_Q0[4]
set_location_assignment PIN_AG21 -to o_instructionlatch_Q0[3]
set_location_assignment PIN_AA20 -to o_instructionlatch_Q0[2]
set_location_assignment PIN_AE22 -to o_instructionlatch_Q0[1]
set_location_assignment PIN_AF21 -to o_instructionlatch_Q0[0]

set_location_assignment PIN_AG14 -to o_instructionlatch_Q1[7]
set_location_assignment PIN_AE6 -to o_instructionlatch_Q1[6]
set_location_assignment PIN_AE24 -to o_instructionlatch_Q1[5]
set_location_assignment PIN_AD20 -to o_instructionlatch_Q1[4]
set_location_assignment PIN_AD17 -to o_instructionlatch_Q1[3]
set_location_assignment PIN_AC22 -to o_instructionlatch_Q1[2]
set_location_assignment PIN_AB23 -to o_instructionlatch_Q1[1]
set_location_assignment PIN_W11 -to o_instructionlatch_Q1[0]

set_location_assignment PIN_AC24 -to i_capturebyte
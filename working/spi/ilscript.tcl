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
set_location_assignment pin_V11  -to i_clk
set_location_assignment PIN_AH26 -to i_spi_clk
#set_location_assignment PIN_AF25 -to i_capturebyte
set_location_assignment PIN_AF23 -to i_csn
set_location_assignment pin_AH22 -to i_rstn
set_location_assignment PIN_AG21 -to o_miso
set_location_assignment PIN_AA20 -to o_datasent
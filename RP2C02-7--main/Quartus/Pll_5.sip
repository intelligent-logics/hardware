set_global_assignment -entity "Pll_5" -library "lib_Pll_5" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "Pll_5" -library "lib_Pll_5" -name IP_TOOL_VERSION "22.1"
set_global_assignment -entity "Pll_5" -library "lib_Pll_5" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_Pll_5" -name SPD_FILE [file join $::quartus(sip_path) "Pll_5.spd"]

set_global_assignment -library "lib_Pll_5" -name MISC_FILE [file join $::quartus(sip_path) "Pll_5_sim/Pll_5.vo"]

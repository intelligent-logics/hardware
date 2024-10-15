set_global_assignment -entity "clkpll" -library "lib_clkpll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clkpll" -library "lib_clkpll" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "clkpll" -library "lib_clkpll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clkpll" -name SPD_FILE [file join $::quartus(sip_path) "clkpll.spd"]

set_global_assignment -library "lib_clkpll" -name MISC_FILE [file join $::quartus(sip_path) "clkpll_sim/clkpll.vo"]

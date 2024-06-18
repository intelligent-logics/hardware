transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1 {I:/clone_fpganes/fpganes-1/system_clock.vo}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/system_clock {I:/clone_fpganes/fpganes-1/system_clock/system_clock_0002.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1 {I:/clone_fpganes/fpganes-1/ram.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/vga.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/nes.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/mmu.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/MicroCode.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/hw_uart.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/hw_sound.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/hq2x.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/cpu.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/compat.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/apu.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1 {I:/clone_fpganes/fpganes-1/fpganes_clone.v}
vlog -vlog01compat -work work +incdir+I:/clone_fpganes/fpganes-1/src {I:/clone_fpganes/fpganes-1/src/ppu.v}

